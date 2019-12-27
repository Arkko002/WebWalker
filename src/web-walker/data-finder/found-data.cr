require "./contact-info"

  class FoundData
    getter contact_info : Array(ContactInfo)

    def initialize
      @contact_info = Array(ContactInfo).new
    end
  end
