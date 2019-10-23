require "uri"
require "http/client"
require "crystagiri"
require "./WebWalker/Website"
require "./WebWalker/Page"
require "./WebWalker/ScrapingOptions"
require "./WebWalker/UrlParser"

# TODO: Write documentation for `WebWalker`
module WebWalker
  VERSION = "0.1.0"

  #TODO Global hash of all links, refrence page links from global hash,
  #ignore ecountered links that are already in global hash
  class WebWalker
    property scraped_website : Website
    property scraping_options : ScrapingOptions


    def initialize(scraping_options : Hash(String, String))
      @scraping_options = ScrapingOptions.new(scraping_options)
      @scraped_website = Website.new(Hash(String, Page).new())
    end

    def start_scraping()
      scrape_page(@scraping_options.initial_url)
      debug_print()
    end

    private def scrape_page(page_url : String)
      #puts page_url
      begin
        response = HTTP::Client.get page_url
      rescue exception
        puts exception.message
        return
      end

      page = Page.new(response.as(HTTP::Client::Response), page_url)
      search_for_links(page)
      @scraped_website.store_scraped_page(page)
      scrape_page_links(page)
    end

    private def search_for_links(page : Page)
      if page.http_response.body.size <= 0
        return
      end

      html_doc = Crystagiri::HTML.new page.http_response.body

      html_doc.where_tag("a") do |tag|
        if !tag.node["href"]?
          next
        end

        url_parser = UrlParser.new tag.node["href"], page.url
        parsed_url = url_parser.parse_link()

        if parsed_url.nil?
          next
        end

        parsed_url = parsed_url.as(String)

        if parsed_url.scan(@scraping_options.initial_url).size != 0
          page.internal_links.push(parsed_url)
        else
          page.external_links.push(parsed_url)
        end
      end
    end

    private def scrape_page_links(page : Page)
      i = 0
      while i < page.internal_links.size
        if @scraped_website.scraped_pages.has_key?(page.internal_links[i])
          i += 1
          next
        end
        #puts page.internal_links[i]
        scrape_page(page.internal_links[i])
        i += 1
      end
    end

    def debug_print()
      @scraped_website.scraped_pages.each_key do |key|
        puts key
      end
    end
  end
end
