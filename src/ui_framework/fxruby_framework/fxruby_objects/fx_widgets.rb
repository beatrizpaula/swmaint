require_relative 'widget'

module FXUI

  module FXWidgets

    class Button < Widget

      include Clickable
      include Readable
      include Writable

      def initialize(parent_widget, label, opts)
        super(parent_widget)
        @ui_object = FXButton.new(parent_widget.ui_object, label, opts)
      end

    end

    class Label < Widget

      include Readable
      include Writable

      def initialize(parent_widget, label, opts)
        super(parent_widget)
        @ui_object = FXLabel.new(parent_widget.ui_object, label, opts)
      end

    end

  end

end