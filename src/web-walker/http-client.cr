require "http/client"
require "./http-client/**"

# Source: https://github.com/crystal-lang/crystal/issues/2963

class HTTPClient < AbstractHTTPClient
  def get_page_with_spoofed_packet(url : String | URI)
    proxy = @proxy_config.get_random_proxy()
    self.set_proxy(proxy)
    self.get(url, headers: @header_config.get_random_header)
  end
end
