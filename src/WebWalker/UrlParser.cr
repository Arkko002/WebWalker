class UrlParser
  @relative_link : String
  @site_url : String

  def initialize(@relative_link, @site_url)
  end

  def parse_url_into_absolute() : String
    if @relative_link[0, 2] == "//"
      protocol_relative_into_absolute()
    elsif @relative_link[0, 1] == "/"
      relative_into_absolute()
    else
      converted_link = @site_url + @relative_link
    end
  end

  private def protocol_relative_into_absolute() : String
    converted_link = @relative_link.gsub("//", "")
    converted_link = "https://" + converted_link
  end

  private def relative_into_absolute() : String
    converted_link = URI.parse(@site_url).resolve(@relative_link).to_s
  end
end
