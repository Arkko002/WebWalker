require "json"
require "./website-saver/data-parser.cr"
require "./web-walker/data/website.cr"
require "./web-walker/data/page.cr"

module WebsiteSaver
  class WebsiteSaver
    def initialize()
      @data_parser = DataParser.new
    end

    def save_to_file(data)
      data_xml = @data_parser.data_to_xml(data)
      File.write("scraped_xml", data_xml, mode: "w")
    end
  end
end
