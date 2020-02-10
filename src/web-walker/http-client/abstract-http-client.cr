require "./*"
require "http/client"

abstract class AbstractHTTPClient < HTTP::Client
  setter proxy_config : HTTPProxyConfigurator
  setter header_config : HTTPHeaderConfigurator

  def initialize(@proxy_config, @header_config, @host, @port = 80, @compress = false)
  end

  def set_proxy(proxy : HTTPProxy) #ameba:disable Style/RedundantBegin
    begin
      @socket = proxy.open(host: @host, port: @port, tls: @tls, connection_options: proxy_connection_options)
    rescue IO::Error
      @socket = nil
    end
  end

  def disable_proxy()
    @socket = socket()
  end

  def proxy_connection_options
    opts = {} of Symbol => Float64 | Nil

    opts[:dns_timeout] = @dns_timeout
    opts[:connect_timeout] = @connect_timeout
    opts[:read_timeout] = @read_timeout

    opts
  end

  abstract def get_page_with_spoofed_packet(url : String | URI)
end
