class SearchObject
  def initialize(urls)
    @urls = urls
  end

  def to_param
    ""
  end

  def to_key
    []
  end

  def model_name
    OpenStruct.new(param_key: :search)
  end

  def urls
    parsed_urls.map(&:to_s).join("\n")
  end

  def parsed_urls
    @parsed_urls ||= @urls.to_s.split("\n").map {|url| parse_url(url) }.compact
  end

  def parse_url(url)
    uri = URI(url.strip)

    uri if uri.absolute?
  rescue ArgumentError
    nil
  end
end
