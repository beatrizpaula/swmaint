require_relative 'ui_component'

module FXUI

  class Composite < UIComponent

    attr_reader :ui_elements

    def initialize(parent)
      super(parent)
      @ui_elements = []
    end

    def find_container_of(feature)
      queue = [self]
      until queue.empty?()
        node = queue.shift()
        node.ui_elements.each do
          |ui_element|
          if ui_element.dedicated_feature == feature
            return node
          elsif ui_element.is_a?(Composite)
            queue.push(ui_element)
          end
        end
      end
      raise(RuntimeError, "No ui container contains your feature #{feature}.")
    end

    def create_ui_element_on_top()
      first_ui_element = @ui_elements.first()

      ui_element = yield(self)
      unless first_ui_element.nil?()
        ui_element.link_before(first_ui_element)
      end

      @ui_elements.unshift(ui_element)
      return ui_element
    end

    def create_ui_element_vertically(relative_to_feature, position)
      return _create_ui_element_relative_to(relative_to_feature, position) do
        |ui_container|
        v_container = nil
        unless ui_container.is_a?(FXLayouts::VerticalFrame)
          v_container = Factory.create_layout(:VerticalFrame, ui_container, :opts => LAYOUT_NORMAL)
        else
          v_container = ui_container
        end
        yield(v_container)
      end
    end

    def create_ui_element_horizontally(relative_to_feature, position)
      return _create_ui_element_relative_to(relative_to_feature, position) do
        |ui_container|
        h_container = nil
        unless ui_container.is_a?(FXLayouts::HorizontalFrame)
          h_container = Factory.create_layout(:HorizontalFrame, ui_container, :opts => LAYOUT_NORMAL)
        else
          h_container = ui_container
        end
        yield(h_container)
      end
    end

    def remove_ui_element(feature)
      index_feature_to_remove = _index_of_feature(feature)

      removed_ui_element = @ui_elements.delete_at(index_feature_to_remove)
      ui_container = removed_ui_element.parent

      if ui_container.has_exactly_one_ui_child?()
        parent_of_ui_container = ui_container.parent
        ui_element_to_move = ui_container.ui_elements.first()
        parent_of_ui_container.replace_ui_element(ui_container, ui_element_to_move)

        parent_of_ui_container.remove_child(ui_container)
      end

      removed_ui_element.parent = nil
      return removed_ui_element
    end

    def detach_ui_element_in_container(feature)
      index_feature_to_detach = _index_of_feature(feature)

      return @ui_elements.delete_at(index_feature_to_detach)
    end

    def push_ui_element(ui_element)
      @ui_elements.push(ui_element)
    end

    def insert_ui_element(index, ui_element)
      @ui_elements.insert(index, ui_element)
    end

    def replace_ui_element(old_ui_element, ui_element)
      index_old_ui_element = @ui_elements.index(old_ui_element)
      @ui_elements[index_old_ui_element] = ui_element

      ui_element_of_concerned_ui_element = @ui_elements[index_old_ui_element + 1]
      ui_element.reparent(self, ui_element_of_concerned_ui_element)
    end

    def has_exactly_one_ui_child?()
      return @ui_elements.length() == 1
    end

    protected

    def _index_of_feature(feature)
      return @ui_elements.index() do
      |ui_element|
        ui_element.dedicated_feature == feature
      end
    end

    def _create_ui_element_relative_to(relative_to_feature, position)
      index_of_relative_to = _index_of_feature(relative_to_feature)
      ui_element_of_relative_to = @ui_elements[index_of_relative_to]
      ui_element_after_container = @ui_elements[index_of_relative_to + 1]

      ui_element_of_feature = yield(self)
      ui_container = ui_element_of_feature.parent

      if ui_container == self
        if position == :before
          ui_container.insert_ui_element(index_of_relative_to, ui_element_of_feature)
        else
          ui_container.insert_ui_element(index_of_relative_to + 1, ui_element_of_feature)
        end
      else
        if position == :before
          ui_container.push_ui_element(ui_element_of_feature)
          ui_container.push_ui_element(ui_element_of_relative_to)
        else
          ui_container.push_ui_element(ui_element_of_relative_to)
          ui_container.push_ui_element(ui_element_of_feature)
        end

        ui_element_of_relative_to.reparent(ui_container)

        unless ui_element_after_container.nil?()
          ui_container.link_before(ui_element_after_container)
        end

        @ui_elements[index_of_relative_to] = ui_container
      end

      method_name_to_position = "link_#{position}"
      ui_element_of_feature.send(method_name_to_position, ui_element_of_relative_to)

      return ui_element_of_feature
    end

  end

end