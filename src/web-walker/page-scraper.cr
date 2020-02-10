require "./http-client"
require "./http-client/abstract-http-client.cr"
require "../../lib/commander/src/commander"
require "./page-scraper/**"
require "./data-types/**"

abstract class AbstractPageScraper
  abstract def scrape_page(page_url : String)
end

class PageScraper < AbstractPageScraper
  getter scraped_website : Website
  setter scraping_options : Commander::Options
  setter http_client : AbstractHTTPClient
  setter url_parser : AbstractUrlParser

  # TODO Add method to stop and resume scraping
  def initialize(@scraped_website, @scraping_options, @url_parser)
    proxy_config = HTTPProxyConfigurator.new(@scraping_options.string["proxy_path"], "proxy_list")
    header_config = HTTPHeaderConfigurator.new(@scraping_options.string["user_agent_path"], "user_agent_list")
    @http_client = HTTPClient.new(proxy_config, header_config, host: @scraping_options.string["url"])
  end

  def scrape_page(page_url : String)
    page = get_scraped_page(page_url)
    if page.nil?
      return
    end

    html_doc = create_html_doc(page)
    if html_doc.nil?
      @scraped_website.store_scraped_page(page)
      return
    end

    links = search_for_links(page.url, html_doc)
    page.store_scraped_links(links)

    page.html_components = search_for_html_components(html_doc)

    @scraped_website.store_scraped_page(page)
    scrape_page_links(page)
  end

  private def get_scraped_page(page_url : String) : Page?
    begin
      response = @http_client.get_page_with_spoofed_packet(page_url)
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

  private def search_for_links(page_url : String, html_doc : Crystagiri::HTML) : Array(String)
    parsed_urls = Array(String).new

    html_doc.where_tag("a") do |tag|
      if !tag.node["href"]?
        next
      end

      parsed_url = @url_parser.parse_link(tag.node["href"], page_url)

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
    page.internal_links.each() do |link|
      if @scraped_website.scraped_pages.has_key?(link)
        next
      end
      scrape_page(link)
    end
  end
end
