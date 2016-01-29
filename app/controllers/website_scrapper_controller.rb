class WebsiteScrapperController < ApplicationController
  def create
    scrapped_results = MultipleWebsiteScrapper.new(urls: search.parsed_urls).fetch

    if scrapped_results.valid?
      @results = scrapped_results.data
    else
      @errors = scrapped_results.errors
    end

    render :index
  end

  protected

  def website_params
    params.fetch(:search, {}).permit(:urls)
  end

  helper_method def search
    SearchObject.new(website_params[:urls])
  end

  helper_method def results
    @results || []
  end

  helper_method def errors
    @errors || []
  end
end
