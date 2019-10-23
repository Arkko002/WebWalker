require "uri"

struct ScrapingOptions
  getter initial_url : String
  getter search_deep = true
  getter searched_value : String?

  def initialize(options : Hash)
      @initial_url = options["url"]

      if options["search_deep"] == "n"
          @search_deep = false
      end

      @searched_value = options["searched_value"]
  end
end
