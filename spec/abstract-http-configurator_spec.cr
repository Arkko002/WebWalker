require "./spec_helper"

describe AbstractHTTPConfigurator do

  #Use before_each instead of after_each to prevent race conditioning
  before_each do
    if File.exists?("proxy_list")
      File.delete("proxy_list")
    end
  end

  describe ".initialize" do
    it "should download a list from given url if the list doesn't exist" do
      configurator = MockHTTPConfigurator.new("https://raw.githubusercontent.com/clarketm/proxy-list/master/proxy-list-raw.txt", "proxy_list")

      configurator.file_existed.should be_false
    end
  end

  describe ".pull_list" do
    it "should download a list with parameters provided in initalisation" do
      configurator = MockHTTPConfigurator.new("https://raw.githubusercontent.com/clarketm/proxy-list/master/proxy-list-raw.txt", "proxy_list")

      File.exists?("proxy_list").should be_true
    end
  end
end
