require 'fox16'
include Fox

Dir[File.expand_path("..", File.dirname(__FILE__)) + "/fxruby_properties/*.rb"].each { |file| require file }

# Include the base object
require_relative 'ui_object'

require_relative 'app'
require_relative 'main_window'

# Include the layouts of the framework
require_relative 'fx_layouts'

# Include the widgets of the framework
require_relative 'fx_widgets'

module FXUI

  module Factory

    class << self

      @@FXUI_NAMESPACE = Module.const_get("FXUI")
      @@LAYOUTS_NAMESPACE = @@FXUI_NAMESPACE.const_get("FXLayouts")
      @@WIDGETS_NAMESPACE = @@FXUI_NAMESPACE.const_get("FXWidgets")

      def create_app(&block)
        klass = _get_class(:App, @@FXUI_NAMESPACE)
        return klass.new(&block)
      end

      def create_main_window(*args)
        klass = _get_class(:MainWindow, @@FXUI_NAMESPACE)
        main_window = klass.new(*args)
        FXUIManager.instance.main_container = main_window
        return main_window
      end

      def create_layout(type, container, *args)
        return _create(@@LAYOUTS_NAMESPACE, type, container, *args)
      end

      def create_widget(type, container, *args)
        return _create(@@WIDGETS_NAMESPACE, type, container, *args)
      end

      def create_ui_object(type, container, *args)
        if @@LAYOUTS_NAMESPACE.constants.include?(type)
          return self.create_layout(type, container, *args)
        elsif @@WIDGETS_NAMESPACE.constants.include?(type)
          return self.create_widget(type, container, *args)
        else
          raise(NameError, "\"#{type}\" does not exist neither in the namespace \"#{@@LAYOUTS_NAMESPACE.name}\", nor in the namespace \"#{@@WIDGETS_NAMESPACE.name}\".")
        end
      end

      # Method to create an ui element for a specific feature
      def create_ui_object_for_feature(feature, type, container, *args)
        ui_object = nil
        if @@LAYOUTS_NAMESPACE.constants.include?(type)
          ui_object = self.create_layout(type, container, *args)
        elsif @@WIDGETS_NAMESPACE.constants.include?(type)
          ui_object = self.create_widget(type, container, *args)
        else
          raise(NameError, "\"#{type}\" does not exist neither in the namespace \"#{@@LAYOUTS_NAMESPACE.name}\", nor in the namespace \"#{@@WIDGETS_NAMESPACE.name}\".")
        end
        ui_object.dedicated_feature = feature
        return ui_object
      end

      private

      def _create(namespace, type, container, *args, &block)
        klass = _get_class(type, namespace)
        ui_element = klass.new(container, *args, &block)
        if container.created?()
          # This condition allows to create and show dynamically ui elements (only at runtime, when a feature is activated)
          ui_element.create_and_show()
        end
        return ui_element
      end

      def _get_class(classname, namespace)
        unless namespace.const_defined?(classname)
          raise(NameError, "\"#{classname}\" does not exist in the namespace \"#{namespace}\".")
        end
        return namespace.const_get(classname)
      end

    end

  end

end
