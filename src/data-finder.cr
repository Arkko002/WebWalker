require "./data-finder/**"
require "./web-walker/data-types/html-component.cr"
require "./web-walker/data-types/page.cr"

class DataFinder
  @email_regex = /^[a-zA-Z0-9.!#$%&'*+\=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
  @phone_number_regex = /^(?:\d+(?:\d{2}(?:\d{2})?)?|\(\+?\d{2,3}\)\s?(?:\d{4}[\s*.-]?\d{4}|\d{3}[\s*.-]?\d{3}|\d{2}([\s*.-]?)\d{2}\1\d{2}(?:\1\d{2})?))$/

  def initialize(@page : Page)
  end

  def look_for_data(data_type : Class) : Data
    case data_type
    when ContactInfo
      data = find_contact_info()
    end

    data
  end

  private def find_contact_info() : ContactInfo
    @page.html_components.each() do |component|
      email_matchdata = @email_regex.match(component.content)
      phone_number_matchdata = @phone_number_regex.match(component.content)

      if !email_matchdata.nil? || !phone_number_matchdata.nil?
        found_contact = ContactInfo.new(phone_number_matchdata.to_a,
                                        email_matchdata.to_a,
                                        physical_adresses: Array(String?).new,
                                        component_parent: component)

        @page.found_data.push(found_contact)
      end
    end
  end
end
