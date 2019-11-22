require "uri"
require "http/client/response"
require "./html-component"

class Page
  property internal_links : Array(String)
  property external_links : Array(String)
  property html_components : Array(HTMLComponent)
  getter url : String
  getter http_response : HTTP::Client::Response


  def initialize(@http_response : HTTP::Client::Response, @url : String)
    @internal_links = Array(String).new
    @external_links = Array(String).new
    @html_components = Array(HTMLComponent).new
    @found_data = Array(Data).new
  end

  def store_scraped_links(initial_url : String, links : Array(String))
    i = 0
    while i < links.size
        #TODO Find if link is actually internal, not if link contains initial url
        if links[i].scan(initial_url).size != 0
          @internal_links.push(links[i])
        else
          @external_links.push(links[i])
        end
      i += 1
    end
  end
end
