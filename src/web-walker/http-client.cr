require "http/client"
require "./http-client/**"

#Source: https://github.com/crystal-lang/crystal/issues/2963
class HTTPClient < ::HTTP::Client
  proxy_config : HTTPProxyConfigurator
  header_config : HTTPHeaderConfigurator

  def set_proxy(proxy : HTTPProxy)
    begin
      @socket               =   proxy.open(host: @host, port: @port, tls: @tls, connection_options: proxy_connection_options)
    rescue IO::Error
      @socket               =   nil
    end
  end

  def proxy_connection_options
    opts                    =   {} of Symbol => Float64 | Nil

    opts[:dns_timeout]      =   @dns_timeout
    opts[:connect_timeout]  =   @connect_timeout
    opts[:read_timeout]     =   @read_timeout

    return opts
  end

  def set_configurators(path_to_proxies, user_agent_list_adr)
    @proxy_config = HTTPProxyConfigurator.new(path_to_proxies)
    @header_config = HTTPHeaderConfigurator.new(path_to_user_agents)
  end

  def get_page_with_spoofed_packet(url : String | URI)
    self.set_proxy(@proxy_config.get_random_proxy())
    self.get(url, headers: @header_config.get_random_header())
  end

end
