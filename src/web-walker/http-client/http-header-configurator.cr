require "http/headers"
require "../../util/util"

#TODO Add file option
class HTTPHeaderConfigurator
  @path_to_user_agents = "https://gist.githubusercontent.com/pzb/b4b6f57144aea7827ae4/raw/cf847b76a142955b1410c8bcef3aabe221a63db1/user-agents.txt"

  #Let user provide his own list, otherwise use the default provided above
  def initialize(@path_to_user_agents = @path_to_user_agents)
    pull_user_agent_list()
  end

  private def pull_user_agent_list()
    system "curl #{@path_to_user_agents} >> list"
  end

  def get_random_header() : HTTP::Headers
    status, output = run_cmd("shuf", ["-n 1", "list"])

    if status == 0
      HTTP::Headers{"User-Agent" => output}
    else
      #TODO
      raise Exception.new
    end
  end
end
