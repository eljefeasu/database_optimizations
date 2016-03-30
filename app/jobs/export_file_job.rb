require 'csv'

class ExportFileJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    name = args[0]
    address = args[1]
    results = []
    name.split(" ").each do |w|
      q = "%#{w}%"
      results += Hit.where("match_gene_name LIKE ?", q)
      results += Hit.where(subject: Gene.joins(sequence: :assembly).where("genes.dna LIKE ? OR sequences.dna LIKE ? OR assemblies.name LIKE ?", q, q, q))
    end
    hits = results.uniq

    file_path = Rails.root.join("tmp", "report#{rand(10000)}.csv")
    CSV.open(file_path, "w") do |csv|
      csv << ["Matching Gene Name", "Matching DNA", "Percent Similarity"]
      hits.each do |h|
        csv << [h.match_gene_name, h.match_gene_dna.first(100), h.percent_similarity]
      end
    end

    file = File.open(file_path)

    AWS.config(
        :access_key_id => ENV['AWS_ACCESS_KEY_ID_DB'],
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY_DB']
      )
    s3 = AWS::S3.new
    bucket = s3.buckets[ENV['S3_BUCKET_NAME_DB']]
    object = bucket.objects[File.basename(file)]
    # the file is not the content of the file is the route
    object.write(file: file)
    # save the file and return an url to download it
    url = object.url_for(:read)

    ReportMailer.send_report(url, address).deliver_now
  end
end
