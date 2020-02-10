require "../../src/web-walker/http-client.cr"

class MockHTTPClient < HTTPClient AbstractHTTPClient
  def get_page_with_spoofed_packet(url : String | URI)
    self.disable_proxy()
    self.get(url)
  end
end
