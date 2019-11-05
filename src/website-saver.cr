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
      if !File.exists?("scraped_xml")
        File.write("scraped_xml", @data_parser.generate_xml_header, mode: "a")
      end

      data_xml = @data_parser.data_to_xml(data)
      File.write("scraped_xml", data_xml, mode: "a")
    end
  end
end
