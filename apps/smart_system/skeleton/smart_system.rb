#
# Main class of the system
#
class SmartCalculator # TODO rename the class - DONE

  class << self

    include CodeExecutionAtLaunchTime

    def run()
      # TODO rename the variable "smart_system" - DONE
      smart_calculator = FXUI::Factory.create_app() do
        |app|
        SmartCalculator.new(app) # TODO use the correct classname - DONE
      end
      smart_system.run()
    end

  end

  attr_reader :main_window

  def initialize(app)
    @main_window = FXUI::Factory.create_main_window(app, "Smart Calculator", app_width(), app_height()) # TODO give another title of your system - DONE
    # TODO
    @main_window.show(PLACEMENT_SCREEN)
  end

  def app_width()
    return 600
  end

  def app_height()
    return 800
  end

end