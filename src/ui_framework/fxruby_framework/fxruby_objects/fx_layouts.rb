require_relative 'layout'

module FXUI

  module FXLayouts

    class HorizontalFrame < Layout

      def initialize(parent_widget, opts)
        super(parent_widget)
        @ui_object = FXHorizontalFrame.new(parent_widget.ui_object, opts)
      end

    end

    class Matrix < Layout

      def initialize(parent_widget, n, opts)
        super(parent_widget)
        @ui_object = FXMatrix.new(parent_widget.ui_object, n, opts)
      end

    end

    class Packer < Layout

      def initialize(parent_widget, opts)
        super(parent_widget)
        @ui_object = FXPacker.new(parent_widget.ui_object, opts)
      end

    end

    class VerticalFrame < Layout

      def initialize(parent_widget, opts)
        super(parent_widget)
        @ui_object = FXVerticalFrame.new(parent_widget.ui_object, opts)
      end

    end

  end

end