require "http/headers"

#TODO Add file option
class HTTPHeaderConfigurator
  @user_agent_list_adr = "https://gist.githubusercontent.com/pzb/b4b6f57144aea7827ae4/raw/cf847b76a142955b1410c8bcef3aabe221a63db1/user-agents.txt"

  #Let user provide his own list, otherwise use the default provided above
  def initialize(@user_agent_list_adr = @user_agent_list_adr)
    pull_user_agent_list()
  end

  private def pull_user_agent_list()
    system "curl #{@user_agent_list_adr} >> list"
  end

  def get_random_header() : HTTP::Headers
    status, output = run_cmd("shuf", ["-n 1", "list"])

    if status == 0
      return HTTP::Headers{"User-Agent" => output}
    else
      #TODO
      raise Exception
    end
  end
end
