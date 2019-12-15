require "crystagiri"
require "./data-finder/**"
require "./web-walker/data-types/html-component.cr"
require "./web-walker/data-types/page.cr"
require "./data-finder/lib-postal/libpostal.cr"

class DataFinder
  @email_regex = /^[a-zA-Z0-9.!#$%&'*+\=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
  @phone_number_regex = /^(?:\d+(?:\d{2}(?:\d{2})?)?|\(\+?\d{2,3}\)\s?(?:\d{4}[\s*.-]?\d{4}|\d{3}[\s*.-]?\d{3}|\d{2}([\s*.-]?)\d{2}\1\d{2}(?:\1\d{2})?))$/

  def initialize(@html_component : HTMLComponent, @found_data : FoundData)
    @html_doc = Crystagiri::HTML.new @html_component.content
  end

  def look_for_data(data_type : Class)
    case data_type
    when ContactInfo
      find_contact_info()
    when ProductInto
      find_price_info()
    end
  end

  private def find_contact_info() : ContactInfo
    address_data = LibPostal.address_parser_parse(@html_component.content, "", "")
    email_matchdata = @email_regex.match(@html_component.content)
    phone_number_matchdata = @phone_number_regex.match(@html_component.content)

    if !email_matchdata.nil? || !phone_number_matchdata.nil?
      found_contact = ContactInfo.new(phone_number_matchdata.to_a,
                                      email_matchdata.to_a,
                                      physical_adresses: Array(String?).new,
                                      component_parent: @html_component)

      @found_data.contact_info.push(found_contact)
    end
  end

  private def find_product_info() : PriceInfo
    #TODO Match for productTitle, productName etc. and use the match to .where_tag(MATCH)
    @html_doc
    found_product = ProductInfo.new()
  end
end
