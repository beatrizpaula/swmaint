require 'singleton'

require_relative 'factory'

class FXUIManager

  include Singleton

  attr_writer :main_container

  def initialize()
    @main_container = nil
  end

  def create_ui_element_on_top(feature, type, *args)
    return @main_container.create_ui_element_on_top() do
      |ui_container|
      FXUI::Factory.create_ui_object_for_feature(feature, type, ui_container, *args)
    end
  end

  def create_ui_element_on_top_of(feature, on_top_of_feature, type, *args)
    container = @main_container.find_container_of(on_top_of_feature)
    return container.create_ui_element_vertically(on_top_of_feature, :before) do
      |ui_container|
      FXUI::Factory.create_ui_object_for_feature(feature, type, ui_container, *args)
    end
  end

  def create_ui_element_on_below_of(feature, on_below_of_feature, type, *args)
    container = @main_container.find_container_of(on_below_of_feature)
    return container.create_ui_element_vertically(on_below_of_feature, :after) do
      |ui_container|
      FXUI::Factory.create_ui_object_for_feature(feature, type, ui_container, *args)
    end
  end

  def create_ui_element_on_left_of(feature, on_left_of_feature, type, *args)
    container = @main_container.find_container_of(on_left_of_feature)
    return container.create_ui_element_horizontally(on_left_of_feature, :before) do
      |ui_container|
      FXUI::Factory.create_ui_object_for_feature(feature, type, ui_container, *args)
    end
  end

  def create_ui_element_on_right_of(feature, on_right_of_feature, type, *args)
    container = @main_container.find_container_of(on_right_of_feature)
    return container.create_ui_element_horizontally(on_right_of_feature, :after) do
      |ui_container|
      FXUI::Factory.create_ui_object_for_feature(feature, type, ui_container, *args)
    end
  end

  def remove_ui_element(feature)
    container = @main_container.find_container_of(feature)
    return container.remove_ui_element(feature)
  end

  def move_ui_element_on_top_of(feature, on_top_of_feature)
    container_of_feature = @main_container.find_container_of(feature)
    ui_element_of_feature = container_of_feature.detach_ui_element_in_container(feature)

    container_of_on_top_of_feature = @main_container.find_container_of(on_top_of_feature)
    container_of_on_top_of_feature.create_ui_element_vertically(on_top_of_feature, :before) do
      |ui_container|
      ui_element_of_feature.reparent(ui_container)
      ui_element_of_feature
    end
  end

  def move_ui_element_on_below_of(feature, on_below_of_feature)
    container_of_feature = @main_container.find_container_of(feature)
    ui_element_of_feature = container_of_feature.detach_ui_element_in_container(feature)

    container_of_on_below_of_feature = @main_container.find_container_of(on_below_of_feature)
    container_of_on_below_of_feature.create_ui_element_vertically(on_below_of_feature, :after) do
      |ui_container|
      ui_element_of_feature.reparent(ui_container)
      ui_element_of_feature
    end
  end

  def move_ui_element_on_left_of(feature, on_left_of_feature)
    container_of_feature = @main_container.find_container_of(feature)
    ui_element_of_feature = container_of_feature.detach_ui_element_in_container(feature)

    container_of_on_left_of_feature = @main_container.find_container_of(on_left_of_feature)
    container_of_on_left_of_feature.create_ui_element_horizontally(on_left_of_feature, :before) do
      |ui_container|
      ui_element_of_feature.reparent(ui_container)
      ui_element_of_feature
    end
  end

  def move_ui_element_on_right_of(feature, on_right_of_feature)
    container_of_feature = @main_container.find_container_of(feature)
    ui_element_of_feature = container_of_feature.detach_ui_element_in_container(feature)

    container_of_on_right_of_feature = @main_container.find_container_of(on_right_of_feature)
    container_of_on_right_of_feature.create_ui_element_horizontally(on_right_of_feature, :after) do
      |ui_container|
      ui_element_of_feature.reparent(ui_container)
      ui_element_of_feature
    end
  end

end