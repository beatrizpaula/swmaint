require_relative 'ui_object'

module FXUI

  class UIComponent < UIObject

    attr_accessor :dedicated_feature, :parent

    def initialize(parent)
      super()
      @parent = parent
    end

    def create_and_show()
      @ui_object.create()
      @ui_object.show()
      @ui_object.recalc()
    end

    def created?()
      return @ui_object.created?()
    end

    def resize(width, height)
      @ui_object.resize(width, height)
    end

  end

end