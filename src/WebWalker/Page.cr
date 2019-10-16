require "uri"
require "http/client/response"

class Page
    property internal_links : Array(String)
    property external_links : Array(String)
    property visited : Bool
    getter url : String
    getter http_response : HTTP::Client::Response


    def initialize(@http_response : HTTP::Client::Response, @url : String)
      @internal_links = Array(String).new
      @external_links = Array(String).new
      @visited = false
    end
end
