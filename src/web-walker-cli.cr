require "option_parser"
require "./web-walker"

options = Hash(String, String).new
options["searched_value"] = ""
options["search_deep"] = "y"

OptionParser.parse do |parser|
    parser.banner = "Usage: webwalker -u [URL] -v [Searched value (optional)]"

    parser.missing_option { puts parser }

    parser.invalid_option do |flag|
      STDERR.puts "ERROR: #{flag} is not a valid option."
      STDERR.puts parser
      exit(1)
  end

    parser.on("-u URL", "--url=URL", "Starting URL") { |url| options["url"] = url}
    parser.on("-d DEEP", "--deep=DEEP", "Search through all found subpages? (\"y\" or \"n\")") { |deep| options["search_deep"] = deep }
    parser.on("-v VALUE", "--value=VALUE", "Searched value") { |value| options["searched_value"] = value }
    parser.on("-h", "--help", "Show help") { puts parser }
end

walker = WebWalker::WebWalker.new(options)
walker.start_scraping()
