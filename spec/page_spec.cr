require "./spec_helper"

describe Page do
  page = Page.new(HTTP::Client::Response.new(HTTP::Status.new(200)), "crystal-lang.org")

  before_each do
    page.internal_links.clear()
    page.external_links.clear()
  end

  describe ".store_scraped_links" do
    it "should detect and store links from the domain" do
      page.store_scraped_links(["crystal-lang.org/api/"])
      page.internal_links[0].should eq("crystal-lang.org/api/")
    end

    it "should detect and store links leading away from domain" do
      page.store_scraped_links(["www.google.com"])
      page.external_links[0].should eq("www.google.com")
    end
  end
end
