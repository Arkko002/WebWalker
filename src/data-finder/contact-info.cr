require "./data"


class ContactInfo < Data
  getter phone_numbers : Array(String?)
  getter email_adresses : Array(String?)

  #TODO research possibility of extracting street addresses
  getter physical_adresses : Array(String?)

  def initialize(@phone_numbers, @email_adresses, @physical_adresses, @component_parent)
  end
end
