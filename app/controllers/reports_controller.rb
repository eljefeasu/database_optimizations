class ReportsController < ApplicationController
  helper_method :memory_in_mb

  def all_data
    @start_time = Time.now
    @assembly = Assembly.find_by_name(params[:name])
    @hits = @assembly.hits.order(percent_similarity: :desc)

    @memory_used = memory_in_mb
  end

  def search
    if request.post?
      @name = params[:name]
      @address = params[:address]
      ExportFileJob.perform_later(@name, @address)
    end
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
