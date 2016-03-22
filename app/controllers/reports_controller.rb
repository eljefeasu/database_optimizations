class ReportsController < ApplicationController
  helper_method :memory_in_mb

  def all_data
    @start_time = Time.now
    @assembly = Assembly.find_by_name(params[:name])
    @hits = @assembly.hits.order(percent_similarity: :desc)

    @memory_used = memory_in_mb
  end

  def search
    # @hits = Hit.joins("JOIN genes ON genes.id = hits.subject_id AND hits.subject_type = 'Gene'")
    #    .joins("JOIN sequences ON sequences.id = genes.sequence_id")
    #    .joins("JOIN assemblies ON assemblies.id = sequences.assembly_id")
    #    .where("assemblies.name LIKE '%?%' OR genes.dna LIKE '%?%' OR hits.match_gene_name LIKE '%?%',
    #         params[:search], params[:search], params[:search])
    #    .order("hits.percent_similarity DESC")



    @start_time = Time.now
    name = params["name"]
    @assemblies = Assembly.where("name LIKE ?", "%#{name}%")
    @genes = Gene.where("dna like ?", "%#{name}%")
    @hits = Hit.where("match_gene_name like ?", "%#{name}%")
    @memory_used = memory_in_mb
  end

  def import

  end

  def thank_you
    csv = params[:file].path
    ImportFileJob.perform_later(csv)
  end

  private def memory_in_mb
    `ps -o rss -p #{$$}`.strip.split.last.to_i / 1024
  end
end
