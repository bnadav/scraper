class Page < ApplicationRecord

  attr_writer :scrape_error_msg

  validate :scrape_ok

  serialize :content, JSON

  # Scrape given url
  def self.scrape(url)
    page = Page.where(url: url).first_or_initialize
    scraper = PageScraper.new(url).call
    if scraper.status == :ok
      page.content = scraper.content
    else
      # copy errors from to instance variables that is checked in the validation phase
      page.scrape_error_msg = scraper.error_msg
    end
    page
  end

  def scrape_ok
    errors.add(:url, @scrape_error_msg) if @scrape_error_msg
  end

end
