require "http/headers"
require "./abstract-http-configurator"
require "../../util/util"

class HTTPHeaderConfigurator < AbstractHTTPConfigurator
  def get_random_header() : HTTP::Headers
    status, output = run_cmd("shuf", ["-n 1", "#{@filename_to_save}"])

    if status == 0
      HTTP::Headers{"User-Agent" => output.chomp()}
    else
      #TODO
      raise Exception.new
    end
  end
end
