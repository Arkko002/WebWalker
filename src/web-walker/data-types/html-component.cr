
#TODO Detect components inside of component and assign them as children
class HTMLComponent
  property id : String?
  property component_class : String?
  property found_data : Array(Class)
  property content : String

  def initialize(@id, @component_class, @content, @found_data)
  end
end
