class MultipleWebsiteScrapper
  class Result
    def initialize(data: nil, errors: [])
      @data = data
      @errors = errors
    end

    attr_reader :data, :errors

    def valid?
      errors.empty?
    end
  end

  def initialize(urls:)
    @urls = urls || []
  end

  def fetch(scrapper = WebsiteScrapper)
    if urls.count > 3
      Result.new(errors: ["Max 3 websites!"])
    else
      Result.new(data: urls.map {|url| scrapper.fetch(url) })
    end
  end

  private

  attr_reader :urls
end
