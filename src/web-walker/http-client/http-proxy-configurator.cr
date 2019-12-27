require "random"
require "time"
require "./http-proxy"

#TODO Add curl option
class HTTPProxyConfigurator
  setter path_to_list : String
  setter proxy_list : Array(String)

  def initialize(@path_to_list)
    @proxy_list = Array(String).new
    load_proxies_from_path()
  end

  private def load_proxies_from_path()
    #TODO Add support for CSV
    proxy_str = File.read(@path_to_list)
    proxy_str.split(",") { |s| @proxy_list << s }
  end

  def get_random_proxy() : HTTPProxy
    r = Random.new(Time.local.to_unix)
    proxy_adr = @proxy_list[r.next_int % @proxy_list.size]

    HTTPProxy.new(proxy_adr)
  end
end
