require "../spec_helper"

class MockHTTPConfigurator < AbstractHTTPConfigurator
  getter file_existed

  def initialize(@url_to_list : String, @filename_to_save : String)
    @file_existed = true

    if !File.exists?(@filename_to_save)
      @file_existed = false
      pull_list()
    end
  end

  def pull_list()
    system "curl #{@url_to_list} >> #{@filename_to_save}"
  end
end
