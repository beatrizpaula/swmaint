require_relative 'ui_object'

module FXUI

  class App < UIObject

    def initialize()
      @ui_object = FXApp.new()
      yield(@ui_object)
      @ui_object.create()
    end

    def run()
      @ui_object.run()
    end

  end

end
