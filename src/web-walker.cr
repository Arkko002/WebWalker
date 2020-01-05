require "uri"
require "crystagiri"
require "commander/src/commander/options"
require "./web-walker/**"

# TODO: Write documentation for `WebWalker`
module WebWalker
  VERSION = "0.1.0"

  class WebWalker
    setter scraping_options : Commander::Options
    setter output_method : AbstractOutput
    setter page_scraper : AbstractPageScraper

    def initialize(@scraping_options, @output_method, @page_scraper)
      @page_scraper.scrape_page(@scraping_options.string["url"])
    end
  end
end
