module FXUI

  class UIObject

    include Rewritable

    attr_reader :ui_object

    def method_missing(method_name, *args, &block)
      puts "The method #{method_name} is not yet implemented in the different properties in the current object."
      return @ui_object.send(method_name, *args, &block)
    end

  end

end