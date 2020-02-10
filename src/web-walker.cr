require "uri"
require "../lib/crystagiri/src/crystagiri"
require "../lib/commander/src/commander"
require "./web-walker/**"

# TODO: Write documentation for `WebWalker`
module WebWalker
  VERSION = "0.1.0"

  class WebWalker
    getter scraping_options : Commander::Options
    getter output_method : AbstractOutput
    getter page_scraper : AbstractPageScraper

    def initialize(@scraping_options, @output_method, @page_scraper)
    end

    def scrape_website_and_output_result()
      @page_scraper.scrape_page(@scraping_options.string["url"])
      @output_method.output_all_xml(@page_scraper.scraped_website)
    end
  end
end
