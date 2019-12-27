require "../data-types/**"

abstract class Data
  getter component_parent : HTMLComponent

  def initialize(@component_parent)
  end
end
