require "../web-walker/data-types/html-component.cr"

abstract class Data
  getter component_parent : HTMLComponent

  def initialize(@component_parent)
  end
end
