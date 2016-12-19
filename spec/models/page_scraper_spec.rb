#require_relative '../../app/services/page_scraper'

RSpec.describe "PageScraper" do

  describe '#call' do
    let (:html_with_content) do
      <<-EOS
        <html>
          <head><title>Title</title></head>
          <body>
            <h1>header1</h1>
            <h2>header2</h2>
            <h3>header3</h3>
            <a href='non'>link</a>
          </body>
        </html>
      EOS
    end
    it "scraps contnet of page" do
      scraper =  PageScraper.new("http://www.uri.com")
      # stub open-uri method
      allow(scraper).to receive(:open).and_return(html_with_content)
      result = scraper.call
      expect(result).to have_attributes(status: :ok, 
                                        content:  {"h1"=>["header1"], "h2"=>["header2"], "h3"=>["header3"], "a"=>["link"]})
    end
    it "flags error status given illegal url" do
      scraper =  PageScraper.new("")
      result = scraper.call
      expect(result).to have_attributes(status: :error, content: {})
      expect(result.content['h1']).to eq([]) # result.content return [] for any key
    end
  end

end
