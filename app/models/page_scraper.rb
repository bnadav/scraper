require 'open-uri'
class PageScraper

  TAGS = ['h1', 'h2', 'h3', 'a']

  Result = Struct.new(:status, :error_msg, :content)

  attr_reader :url

  def initialize(url)
    @url = url
  end

  def call
    begin
      doc = open_and_scrap_url
      content = TAGS.inject({}) {|hsh, tag| hsh[tag] = doc.css(tag).map(&:text); hsh}
    rescue StandardError => e
      result = Result.new(:error, e.message, Hash.new([]))
    else
      result = Result.new(:ok, "", content)
    end
  end

  def open_and_scrap_url
    Nokogiri::HTML(open(url))
  end

end
