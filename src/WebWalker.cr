require "uri"
require "http/client"
require "./WebWalker/Website"
require "./WebWalker/Page"
require "./WebWalker/ScrapingOptions"
require "crystagiri"

# TODO: Write documentation for `WebWalker`
module WebWalker
  VERSION = "0.1.0"

  class WebWalker
    property scraped_website : Website
    property scraping_options : ScrapingOptions

    def initialize(scraping_options : Hash(String, String))
      @scraping_options = ScrapingOptions.new(scraping_options)
      @scraped_website = Website.new Array(Page).new
    end

    def start_scraping()
      scrape_page(@scraping_options.initial_url)
    end

    private def scrape_page(page_url : String)
      response = HTTP::Client.get page_url
      page = Page.new(response)
      @scraped_website.scraped_pages.push(page)

      search_for_links(page)
      scrape_page_links(page)
    end

    private def search_for_links(page : Page)
      html_doc = Crystagiri::HTML.new page.http_response.body

      #TODO Use regex to check for internal links
      html_doc.where_tag("a") do |tag|
        puts tag.node["href"]

      end
    end

    private def scrape_page_links(page : Page)
      i = 0
      while i < page.internal_links.size
        link = page.internal_links[i]
        i += 1
        scrape_page(link)
      end
    end
  end
end
