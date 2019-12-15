require "commander/src/commander"
require "./web-walker"

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
    walker = WebWalker::WebWalker.new(options)
  end
end



