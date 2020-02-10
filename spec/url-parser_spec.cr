require "./spec_helper"

describe UrlParser do
  url_parser = UrlParser.new

  describe ".parse_link" do
    it "should return initial if link is in correct format" do
      result = url_parser.parse_link("https://crystal-lang.org/api", "https://crystal-lang.org")
      result.should eq("https://crystal-lang.org/api")
    end

    it "should return Nil if link is a fragment identifier" do
      result = url_parser.parse_link("https://crystal-lang.org/api#", "https://crystal-lang.org")
      result.should be_nil
    end

    it "should parse relative URLs into absolute" do
      result = url_parser.parse_link("/api", "https://crystal-lang.org")
      result.should eq("https://crystal-lang.org/api")
    end

    it "should parse protocol relative URLs into absolute" do
      result = url_parser.parse_link("//api", "https://crystal-lang.org")
      result.should eq("https://crystal-lang.org/api")
    end
  end
end
