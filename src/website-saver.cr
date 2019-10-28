require "json"
require "./website-saver/page-parser"

#TODO Lazy saving into JSON / XML file
module WebsiteSaver
  class WebsiteSaver
    def initialize(@page)
      @page_parser = WebsiteSaver::PageParser.new
    end

    def save_page()
      @page_json = @page_parser.page_to_json(@page)
      save_to_file()
    end

    private def save_to_file()
      if File.file?("scraped_json")
        append_to_file()
      else
        create_new_file()
      end
    end

    private def append_to_file()
      #TODO
    end

    private def create_new_file()
      File.new("scraped_json", "w")
      File.write("scraped_json", @page_json)
    end
  end
end
