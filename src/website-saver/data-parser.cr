require "xml"
require "../web-walker/data/website.cr"
require "../web-walker/data/page.cr"

module WebsiteSaver
  class DataParser
    def generate_xml_header()
      XML.build() do |xml|
      end
    end

    def data_to_xml(data)
      case data
      when Website
        website_to_xml(data)
      when Page
        page_to_xml(data)
      end
    end

    private def website_to_xml(website : Website)
      website_xml = XML.build() do |xml|
        website.scraped_pages.each_key do |key|
          xml.element("link") {xml.text key}
        end
      end

      remove_xml_header(website_xml)
    end

    private def page_to_xml(page : Page)
      page_xml = XML.build() do |xml|
        xml.element("page") do
          xml.element("url") {xml.text page.url}

          #Commented out for debugging purpouse
          #xml.element("http_response") {xml.text page.http_response.body}

          xml.element("internal_links") do
            page.internal_links.each do |x|
              xml.element("link") {xml.text x}
            end
          end

          xml.element("external_links") do
            page.external_links.each do |x|
              xml.element("link") {xml.text x}
            end
          end
        end
      end

      remove_xml_header(page_xml)
    end

    private def remove_xml_header(xml : String)
      header_end_index = xml.index(">")
      if !header_end_index.nil?
        xml[header_end_index + 1, xml.size]
      end
    end
  end
end
