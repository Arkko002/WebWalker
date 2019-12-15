require "./data"

class ProductInfo < Data
  getter item_name : String
  getter price : String
  getter availability : Bool

  def initialize(@item_name, @price, @availability, @component_parent)
  end
end
