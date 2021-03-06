class WebsiteScrapper
  def self.to_proc
    ->(url) { fetch(url) }
  end

  def self.fetch(website_url)
    new(website_url: website_url).fetch
  end

  def initialize(website_url:, stores: nil, fetcher: nil)
    @website_url = website_url
    @stores = stores
    @fetcher = fetcher
  end

  def fetch
    Result.new(
      url: website_url.to_s,
      data: fetch_result
    )
  end

  private

  attr_reader :website_url

  def fetch_result
    stores.map do |store|
      store.get_app_details(page_header)
    end
  end

  def page_header
    @page_header ||= html_structure.xpath("//head")
  end

  def html_structure
    Nokogiri::HTML(website_content.body)
  end

  def website_content
    fetcher.fetch(website_url)
  end

  def fetcher
    @fetcher ||= Fetcher.new
  end

  def stores
    @stores ||= [Store::PlayStore, Store::AppStore]
  end
end
