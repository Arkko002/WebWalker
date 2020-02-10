require "../../src/web-walker/output-to-console.cr"

class MockConsoleOutput < OutputToConsole
  getter output_string : String

  def initialize(@data_parser)
    @output_string = ""
  end

  def output_website_xml(website : Website)
    @output_string + @data_parser.data_to_xml(website)
  end

  def output_page_xml(page : Page)
    @output_string + @data_parser.data_to_xml(page)
  end
end
