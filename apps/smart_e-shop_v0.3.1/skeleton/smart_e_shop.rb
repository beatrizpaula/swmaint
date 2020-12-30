#
# Main class of the system
#
# Author: Benoît Duhoux
# Date: 2020
#
class SmartEShop < FBCOObject

  class << self

    include CodeExecutionAtLaunchTime

    def run()
      smart_e_shop = FXUI::Factory.create_app() do
        |app|
        SmartEShop.new(app)
      end
      smart_e_shop.run()
    end

  end

  attr_reader :main_window

  def initialize(app)
    @main_window = FXUI::Factory.create_main_window(app, "Smart e-Shop", app_width(), app_height())
    @catalogue_model = CatalogueModel.new()
    @catalogue_view = CatalogueView.new(@catalogue_model)
    @catalogue_view.main_window = @main_window
    @main_window.show(PLACEMENT_SCREEN)
  end

  def resize_app_layout(app_width, app_height)
    @main_window.ui_object.resize(app_width, app_height)
  end

end