class WebsiteScrapper
  class Fetcher
    NullResponse = Struct.new(:body)

    def fetch(website_url)
      client(website_url).get
    rescue Faraday::ConnectionFailed
      NullResponse.new
    end

    private

    def client(website_url)
      @client ||= Faraday.new(url: website_url) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger if Rails.env.development?
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
  end
end
