class CatalogueView < FBCOObject

  attr_accessor :main_window

  def initialize(catalogue_model)
    @catalogue_model = catalogue_model
    @catalogue_model.add_observer(self)
    @has_title = false
  end

  def create_catalogue_layout()
    unless @has_title
      h_frame = FXUI::Factory.create_ui_object(:HorizontalFrame, @main_window, :opts => LAYOUT_FILL_X)

      FXUI::Factory.create_widget(:Label,
                                  h_frame,
                                  "Catalogue",
                                  :opts => LAYOUT_FILL_X|JUSTIFY_CENTER_X)
      @has_title = true
    end
  end

end