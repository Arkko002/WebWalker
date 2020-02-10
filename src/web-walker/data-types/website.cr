require "./page"

class Website
  getter scraped_pages : Hash(String, Page)

  def initialize()
    @scraped_pages = Hash(String, Page).new
  end

  def store_scraped_page(page : Page)
    scraped_pages[page.url] = page

  #   page_links = page.internal_links.concat(page.external_links)

  #   i = 0
  #   while i < page_links.size
  #     @unique_links[page_links[i]] = true
  #     i += 1
  #   end
  end
end
