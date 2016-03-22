require 'csv'

class ImportFileJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    CSV.foreach(args[0], {headers: true}) do |row|
      a = Assembly.create!(name: row["Assembly Name"], run_on: row["Assembly Date"])
      s = Sequence.create!(dna: row["Sequence"], quality: row["Sequency Quality"], assembly_id: a.id)
      g = Gene.create!(dna: row["Gene Sequence"], starting_position: row["Gene Starting Position"], direction: row["Gene Direction"], sequence_id: s.id)
      h = Hit.create!(match_gene_name: row["Hit Name"], match_gene_dna: row["Hit Sequence"], percent_similarity: row["Hit Similarity"], subject_id: g.id, subject_type: "Gene")
    end
  end
end
