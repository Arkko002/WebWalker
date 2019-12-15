require "./data"

class ContactInfo < Data
  getter phone_numbers : Array(String?)
  getter email_adresses : Array(String?)

  #TODO Use regex to find address in html
  getter physical_adresses #TODO Use a struct to store address data

  def initialize(@phone_numbers, @email_adresses, @physical_adresses, @component_parent)
  end
end
