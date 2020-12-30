# Not a good name but don't have a lot of inspiration for the fact to modify the instrinsic properties
# Maybe Composable ?
module Rewritable

  def link_after(ui_element)
    return @ui_object.linkAfter(ui_element.ui_object)
    end

  def link_before(ui_element)
    return @ui_object.linkBefore(ui_element.ui_object)
  end

  def reparent(parent, before_ui_object = nil)
    @parent = parent
    unless before_ui_object.nil?()
      return @ui_object.reparent(parent.ui_object, before_ui_object.ui_object)
    else
      return @ui_object.reparent(parent.ui_object, nil)
    end
  end

  def remove_child(child)
    @ui_object.removeChild(child.ui_object)
  end

end