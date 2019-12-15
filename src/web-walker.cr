require "uri"
require "crystagiri"
require "commander/src/commander/options"
require "./web-walker/**"
require "./website-saver"

# TODO: Write documentation for `WebWalker`
module WebWalker
  VERSION = "0.1.0"

  class WebWalker
    getter scraped_website : Website
    getter scraping_options : Commander::Options

    def initialize(scraping_options : Commander::Options)
      @scraping_options = scraping_options
      @website_saver = WebsiteSaver::WebsiteSaver.new
      @page_scraper = PageScraper.new(@scraping_options)
    end
  end
end
