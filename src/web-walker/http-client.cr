require "http/client"
require "./http-client/**"

# Source: https://github.com/crystal-lang/crystal/issues/2963

# TODO Init configurators on HTTPClient init, make sure compile time is correct
class HTTPClient < HTTP::Client
  setter proxy_config : HTTPProxyConfigurator
  setter header_config : HTTPHeaderConfigurator

  def initialize(scraping_options : Commander::Options, @host, @port = 80, @compress = false)
    @proxy_config = HTTPProxyConfigurator.new(scraping_options.string["path_to_proxies"])
    @header_config = HTTPHeaderConfigurator.new(scraping_options.string["path_to_user_agents"])
  end

  def set_proxy(proxy : HTTPProxy)
    begin
      @socket = proxy.open(host: @host, port: @port, tls: @tls, connection_options: proxy_connection_options)
    rescue IO::Error
      @socket = nil
    end
  end

  def proxy_connection_options
    opts = {} of Symbol => Float64 | Nil

    opts[:dns_timeout] = @dns_timeout
    opts[:connect_timeout] = @connect_timeout
    opts[:read_timeout] = @read_timeout

    return opts
  end

  def get_page_with_spoofed_packet(url : String | URI)
    proxy = @proxy_config.get_random_proxy
    self.set_proxy(proxy)
    self.get(url, headers: @header_config.get_random_header)
  end
end
