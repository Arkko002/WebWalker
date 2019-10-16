require "./Page"

class Website
    property scraped_pages : Hash(String, Page)

    def initialize(@scraped_pages)
    end

end
