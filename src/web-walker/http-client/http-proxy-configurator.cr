require "random"
require "time"
require "./http-proxy"
require "./abstract-http-configurator"

class HTTPProxyConfigurator < AbstractHTTPConfigurator
  def get_random_proxy() : HTTPProxy
    status, output = run_cmd("shuf", ["-n 1", "#{@filename_to_save}"])

    if status == 0
      if output.includes?(":")
        host_tuple = output.partition(":")
        return HTTPProxy.new(proxy_host: host_tuple[0], proxy_port: host_tuple[2].to_i)
      end
      HTTPProxy.new(output)
    else
      #TODO
      raise Exception.new
    end
  end
end
