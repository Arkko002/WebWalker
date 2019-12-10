require "http/headers"

class HTTPHeaderConfigurator
  @default_user_agent_list_adr = "https://gist.githubusercontent.com/pzb/b4b6f57144aea7827ae4/raw/cf847b76a142955b1410c8bcef3aabe221a63db1/user-agents.txt"

  def initialize
    pull_user_agent_list(@default_user_agent_list_adr)
  end

  private def pull_user_agent_list(list_adr = @default_user_agent_list_adr)
    system "curl #{@list_adr} >> list"
  end

  def get_random_header() : HTTP::Headers
    status, output = run_cmd("shuf", ["-n 1", "list"])

    if status == 0
      return output
    else
      #TODO
      raise Exception
    end
  end
end
