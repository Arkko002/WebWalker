require "./spec_helper"

#TODO Parse content of file into XML and check by keys
describe OutputToFile do
  data_parser = DataParser.new
  options = Commander::Options.new

  output = OutputToFile.new(data_parser, options)
  page = Page.new(HTTP::Client::Response.new(status: HTTP::Status.new(200)), "crystal-lang.org")

  #Use before_each instead of after_each to prevent race conditioning
  before_each do
    if File.exists?("scraped_xml")
      File.delete("scraped_xml")
    end
  end

  describe ".output_all_xml" do
  end

  describe ".output_website_xml" do
    it "should write Website data to file" do
      website = Website.new
      website.store_scraped_page(page)

      output.output_website_xml(website)

      File.exists?("scraped_xml").should be_true
      File.read("scraped_xml").includes?("crystal-lang.org").should be_true
    end
  end

  describe ".output_page_xml" do
    it "should write Page data to file" do
      output.output_page_xml(page)

      File.exists?("scraped_xml").should be_true
      File.read("scraped_xml").includes?("crystal-lang.org").should be_true
    end
  end
end
