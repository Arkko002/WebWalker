require "./output/**"
require "./data-types/**"

class OutputToConsole < AbstractOutput
  setter data_parser : AbstractDataParser

  def initialize(@data_parser)
  end

  def output_all_xml(website : Website)
    output_website_xml(website)
    website.scraped_pages.each_value do |page|
      output_page_xml(page)
    end
  end

  def output_website_xml(website : Website)
    puts @data_parser.data_to_xml(website)
  end

  def output_page_xml(page : Page)
    puts @data_parser.data_to_xml(page)
  end
end
