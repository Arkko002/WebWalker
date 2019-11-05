require "uri"
require "http/client"
require "crystagiri"
require "./web-walker/**"
require "./website-saver"

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
      @website_saver = WebsiteSaver::WebsiteSaver.new
    end

    def start_scraping()
      scrape_page(@scraping_options.initial_url)
    end

    private def scrape_page(page_url : String)
      page = get_scraped_page(page_url)
      if page.nil?
        return
      end

      html_doc = create_html_doc(page)
      if html_doc.nil?
        @scraped_website.store_scraped_page(page)
        @website_saver.save_to_file(page)
        return
      end

      links = search_for_links(page.url, html_doc)
      page.store_scraped_links(@scraping_options.initial_url, links)

      scraped_components = search_for_html_components(html_doc)
      page.html_components = scraped_components

      @scraped_website.store_scraped_page(page)
      @website_saver.save_to_file(page)
      scrape_page_links(page)
    end

    private def get_scraped_page(page_url : String) : Page?
      begin
        response = HTTP::Client.get page_url
      rescue exception
        puts exception.message
        return
      end

      Page.new(response.as(HTTP::Client::Response), page_url)
    end

    private def create_html_doc(page : Page) : Crystagiri::HTML?
      if page.http_response.body.size <= 0
        return
      end

      Crystagiri::HTML.new page.http_response.body
    end

    private def search_for_links(page_url : String ,html_doc : Crystagiri::HTML) : Array(String)
      parsed_urls = Array(String).new

      html_doc.where_tag("a") do |tag|
        if !tag.node["href"]?
          next
        end

        url_parser = UrlParser.new tag.node["href"], page_url
        parsed_url = url_parser.parse_link()

        if parsed_url.nil?
          next
        end

        parsed_url = parsed_url.as(String)
        parsed_urls.push(parsed_url)
      end

      parsed_urls
    end

    private def search_for_html_components(html_doc : Crystagiri::HTML) : Array(HTMLComponent)
      scraped_components = Array(HTMLComponent).new

      html_doc.where_tag("div") do |tag|
        html_component = HTMLComponent.new(nil, nil, tag.content)

        if tag.node["id"]?
          html_component.id = tag.node["id"]
        end

        if tag.node["class"]?
          html_component.component_class = tag.node["class"]
        end

        scraped_components.push(html_component)
      end

      scraped_components
    end

    private def scrape_page_links(page : Page)
      i = 0
      while i < page.internal_links.size
        if @scraped_website.scraped_pages.has_key?(page.internal_links[i])
          i += 1
          next
        end
        scrape_page(page.internal_links[i])
        i += 1
      end
    end
  end
end
