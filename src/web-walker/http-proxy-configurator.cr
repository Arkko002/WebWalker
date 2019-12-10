require "random"

class HTTPProxyConfigurator
  path_to_list : String
  proxy_list : Array(String)

  def initialize(@path_to_list)
    load_proxies_from_path()
  end

  private def load_proxies_from_path()
    #TODO Add support for CSV
    proxy_str = File.read(@path_to_list)
    proxy_str.split(",") { |s| @proxy_list << s }
  end

  def get_random_proxy()
    return proxy_list[Random.rand % proxy_list.size]
  end
end
