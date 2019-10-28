module WebsiteSaver
  class PageParser
    def page_to_json(page)
      string = JSON.build do |json|
        json.object do
          json.field "url", page.url
          json.field "http_response", page.http_response
          json.field "internal_links", page.internal_links
          json.field "external_links", page.external_links
        end
      end
    end

    def website_to_json(website)
      #TODO
    end

    def page_to_xml(page)
      #TODO
    end

    def website_to_xml(website)
      #TODO
    end
  end
end

