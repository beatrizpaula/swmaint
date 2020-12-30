#
# Feature to display the catalogue with the constraint of a small layout
#
# Author: Benoît Duhoux
# Date: 2020
#
module DisplaySimpleCatalogueLayout

  user_interface_adaptation()

  module UILayout

    adapts_class :SmartEShop

    set_prologue :resize_app_layout

    def resize_app_layout(app_width=app_width(), app_height=app_height())
      proceed(app_width, app_height)
    end

    def app_width()
      return 400
    end

    def app_height()
      return 600
    end

  end

  module UICatalogueView

    adapts_class :CatalogueView

    set_prologue :create_catalogue_layout
    set_epilogue :remove_catalogue_layout

    def create_catalogue_layout()
      proceed()
      frame = FXUIManager.instance.create_ui_element_on_top(:CatalogueLayout, :VerticalFrame, :opts => LAYOUT_FILL_X)
      @catalogue_model.products().each do
        |product|
        product_view = ProductView.new(product)
        product_view.create_product_layout(frame)
      end
    end

    def remove_catalogue_layout()
      FXUIManager.instance.remove_ui_element(:CatalogueLayout)
    end

    def update()
      self.remove_catalogue_layout()
      self.create_catalogue_layout()
    end

  end

  module UIProductView

    adapts_class :ProductView

    def create_product_layout(frame)
      return FXUI::Factory.create_ui_object(:HorizontalFrame, frame, :opts => LAYOUT_FILL_X)
    end

  end

end