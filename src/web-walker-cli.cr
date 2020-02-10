require "../lib/commander/src/commander"
require "./web-walker"
require "./web-walker/**"

cli = Commander::Command.new do |cmd|
  cmd.use = "WebWalker"

  cmd.flags.add do |flag|
    flag.name = "url"
    flag.short = "-u"
    flag.long = "--url"
    flag.default = ""
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
    flag.default = ""
    flag.description = "Searched value (optional)"
  end

  cmd.flags.add do |flag|
    flag.name = "output_file"
    flag.short = "-o"
    flag.long = "--output"
    flag.default = ""
    flag.description = "File to output to (optional)"
  end

  cmd.flags.add do |flag|
    flag.name = "proxy_path"
    flag.short = "-p"
    flag.long = "--proxy"
    flag.default = "https://raw.githubusercontent.com/clarketm/proxy-list/master/proxy-list-raw.txt"
    flag.description = "URL to a list of proxies"
  end

  cmd.flags.add do |flag|
    flag.name = "user_agent_path"
    flag.short = "-a"
    flag.long = "--agents"
    flag.default = "https://gist.githubusercontent.com/pzb/b4b6f57144aea7827ae4/raw/cf847b76a142955b1410c8bcef3aabe221a63db1/user-agents.txt"
    flag.description = "URL to a list of user-agents"
  end

  cmd.run do |options, _|
    url_parser = UrlParser.new
    website = Website.new
    scraper = PageScraper.new(website, options, url_parser)

    data_parser = DataParser.new
    if options.string["output_file"] != ""
      output_method = OutputToFile.new(data_parser, options)
    else
      output_method = OutputToConsole.new(data_parser)
    end

    walker = WebWalker::WebWalker.new(options, output_method, scraper)
    walker.scrape_website_and_output_result()
  end
end

Commander.run(cli, ARGV)
