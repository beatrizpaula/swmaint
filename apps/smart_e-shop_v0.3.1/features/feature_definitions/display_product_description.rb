#
# Feature to display the description of the product
#
# Author: Benoît Duhoux
# Date: 2020
#
module DisplayProductDescription

  behaviour_adaptation()

  module Behaviour

    adapts_class :ProductModel

    attr_reader :description

    def initialize(product_info)
      proceed(product_info)
      @description = product_info[:description]
    end

  end

  user_interface_adaptation()

  module ViewProduct

    adapts_class :ProductView

    def initialize(product_model)
      proceed(product_model)
      @label_description = nil
    end

    def create_product_layout(frame)
      h_frame = proceed(frame)
      @label_description = FXUI::Factory.create_widget(:Label,
                                                        h_frame,
                                                       @product_model.description,
                                                        :opts => LAYOUT_FILL_X|JUSTIFY_LEFT)
      @label_description.textColor = '#2c3e50'
      return h_frame
    end

    def update(frame)
      proceed(frame)
      @label_name.text = @product_model.name
    end
  end

end