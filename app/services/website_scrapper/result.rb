class WebsiteScrapper
  class Result
    attr_reader :url, :data

    def initialize(url:, data:)
      @url = url
      @data = data
    end
  end
end
