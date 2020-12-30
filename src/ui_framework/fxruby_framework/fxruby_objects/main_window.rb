require_relative 'composite'

module FXUI

  class MainWindow < Composite

    def initialize(app, title, width, height)
      super(nil)
      @ui_object = FXMainWindow.new(app,
                                    title,
                                    :width => width, :height => height)
    end

    def remove_ui_element(feature)
      index_feature_to_remove = _index_of_feature(feature)
      removed_ui_element = @ui_elements.delete_at(index_feature_to_remove)
      ui_container = removed_ui_element.parent
      ui_container.remove_child(removed_ui_element)
      removed_ui_element.parent = nil
      return removed_ui_element
    end

  end

end

