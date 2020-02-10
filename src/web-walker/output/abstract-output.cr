require "../data-types/**"

abstract class AbstractOutput
  abstract def output_all_xml(website : Website)
  abstract def output_website_xml(website : Website)
  abstract def output_page_xml(page : Page)
end
