require "./website-saver/**"
require "./data-types/**"

# TODO Save HTMLComponents
abstract class AbstractWebsiteSaver
  abstract def save_to_file(data)
end

class WebsiteSaver < AbstractWebsiteSaver
  # TODO Fix module collision
  setter data_parser : AbstractDataParser

  def initialize(@data_parser)
  end

  def save_to_file(data)
    if !File.exists?("scraped_xml")
      File.write("scraped_xml", @data_parser.generate_xml_header, mode: "a")
    end

    data_xml = @data_parser.data_to_xml(data)
    File.write("scraped_xml", data_xml, mode: "a")
  end
end
