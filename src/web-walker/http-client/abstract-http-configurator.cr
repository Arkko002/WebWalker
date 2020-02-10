abstract class AbstractHTTPConfigurator
  def initialize(@url_to_list : String, @filename_to_save : String)
    if !File.exists?(@filename_to_save)
      pull_list()
    end
  end

  def pull_list()
    system "curl #{@url_to_list} >> #{@filename_to_save}"
  end
end
