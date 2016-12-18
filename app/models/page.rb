class Page < ApplicationRecord

  attr_writer :scrape_error_msg

  validate :scrape_ok

  def self.scrape(url)
    page = Page.where(url: url).first_or_initialize
    scraper = PageScraper.new(url).call
    if scraper.status == :ok
      page.content = scraper.content
    else
      page.scrape_error_msg = scraper.error_msg
    end
    page
  end

  def scrape_ok
    errors.add(:base, @scrape_error_msg) if @scrape_error_msg
  end

end
