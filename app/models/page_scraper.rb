require 'open-uri'
class PageScraper

  # Tags to consider
  TAGS = ['h1', 'h2', 'h3', 'a']

  # #call return value is instance of this struct
  # <tt>status</tt> +:ok+ or +:error+
  # <tt>error_msg</tt> description of error message
  # <tt>content</tt> content hash. Keys are: h1,h2,h3
  Result = Struct.new(:status, :error_msg, :content)

  attr_reader :url

  def initialize(url)
    @url = url
  end

  # Scrape url, and populate the content hash.
  # Create an return the Result struct
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
