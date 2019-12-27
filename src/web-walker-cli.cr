require "commander/src/commander"
require "./web-walker"
require "./web-walker/**"

cli = Commander::Command.new do |cmd|
  cmd.use = "WebWalker"

  cmd.flags.add do |flag|
    flag.name = "url"
    flag.short = "-u"
    flag.long = "--url"
    flag.description = "Starting URL"
  end

  cmd.flags.add do |flag|
    flag.name = "deep"
    flag.short = "-d"
    flag.long = "--deep"
    flag.default = true
    flag.description = "Should enter found links and scrape them?"
  end

  cmd.flags.add do |flag|
    flag.name = "value"
    flag.short = "-v"
    flag.long = "--value"
    flag.description = "Searched value (optional)"
  end

  cmd.run do |options, arguments|
    #TODO
    url_parser = UrlParser.new
    scraper = PageScraper.new(options, url_parser)

    data_parser = DataParser.new
    website_saver = WebsiteSaver.new(data_parser)

    walker = WebWalker::WebWalker.new(options, website_saver, scraper)
  end
end
