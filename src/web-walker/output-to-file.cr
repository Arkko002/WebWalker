require "./abstract-output"
require "./output/**"
require "./data-types/**"
require "commander/src/commander/options"

# TODO Save HTMLComponents
class OutputToFile < AbstractOutput
  # TODO Fix module collision
  setter data_parser : AbstractDataParser
  setter scraping_options : Commander::Options

  def initialize(@data_parser, @scraping_options)
  end

  def output_all_xml(website : Website)
    output_website_xml(website)
    website.scraped_pages.each_value do |page|
      output_page_xml(page)
    end
  end

  def output_website_xml(website : Website)
    website_xml = @data_parser.data_to_xml(website)
    save_to_file(website_xml)
  end

  def output_page_xml(page : Page)
    page_xml = @data_parser.data_to_xml(page)
    save_to_file(page_xml)
  end

  def save_to_file(xml_string)
    if !File.exists?("scraped_xml")
      File.write(@scraping_options.string["output_file"], @data_parser.generate_xml_header, mode: "a")
    end

    File.write(@scraping_options.string["output_file"], xml_string, mode: "a")
  end
end
