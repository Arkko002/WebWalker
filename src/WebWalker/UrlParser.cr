
class UrlParser

  def initialize(@relative_link : String, @site_url : String)
  end

  def parse_link() : String?
    if is_fragment_identifier?(@relative_link)
      return
    end

    if is_valid_url?(@relative_link)
      @relative_link
    else
      converted_link = parse_url_into_absolute()
      converted_link
    end
  end

  private def is_valid_url?(link : String) : Bool
    reg = Regex.new("(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})")

    if reg.match(link)
      return true
    end


    return false
  end

  private def is_fragment_identifier?(link : String) : Bool
    if link.scan("#").size != 0
      return true
    end

    return false
  end

  private def parse_url_into_absolute() : String
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
    link = URI.parse(@site_url).resolve(@relative_link).to_s
    link
  end
end
