require "./http-client"
require "./page-scraper/**"
require "./data-types/**"

class PageScraper
  getter scraped_website : Website
  getter scraping_options

  #TODO Add method to stop and resume scraping
  def initialize(@scraping_options)
    @scraped_website = Website.new(Hash(String, Page).new())

    scrape_page(@scraping_options.string["url"])
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
      HTTPClient.new(page_url) do |client|
        client.set_configurators(@scraping_options.path_to_proxies, @scraping_options.user_agent_list_adr)
        response = client.get_page_with_spoofed_packet(page_url)
      end
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
    page.internal_links.each() do |link|
      if @scraped_website.scraped_pages.has_key?(link)
        next
      end
      scrape_page(link)
    end
  end
end
