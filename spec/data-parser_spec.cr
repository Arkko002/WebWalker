require "./spec_helper"

describe DataParser do
  describe ".data_to_xml" do
    data_parser = DataParser.new

    it "should output XML on valid input" do
      website = Website.new

      result = data_parser.data_to_xml(website)
      result.empty?.should be_false
    end

    it "should output empty string on invalid input" do
      invalid_object = DataParser.new

      result = data_parser.data_to_xml(invalid_object)
      result.empty?.should be_true
    end
  end
end
