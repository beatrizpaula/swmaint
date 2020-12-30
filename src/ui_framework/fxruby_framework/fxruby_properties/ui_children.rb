module UIChildren

  attr_reader :ui_children

  def initialize()
    @ui_children = []
  end

  def insert_ui_child(index, ui_element)
    @ui_children.insert(index, ui_element)
  end

  def push_ui_child(ui_element)
    @ui_children.push(ui_element)
  end

  def replace_ui_child(index, new_ui_element)
    @ui_children[index] = new_ui_element
  end

  def remove_ui_child_at(index)
    return @ui_children.delete_at(index)
  end

  def has_ui_children?()
    return !@ui_children.empty?()
  end

  def first_ui_child()
    return @ui_children.first()
  end

  def last_ui_child()
    return @ui_children.last()
  end

  def ui_child_at_index(index)
    return @ui_children[index]
  end

  def ui_children()
    return @ui_children
  end

end