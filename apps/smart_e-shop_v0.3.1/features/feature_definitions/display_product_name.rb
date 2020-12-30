#
# Feature to display the product name
#
# Author: Benoît Duhoux
# Date: 2020
#
module DisplayProductName

  behaviour_adaptation()

  module Behaviour

    adapts_class :ProductModel

    attr_reader :name

    def initialize(product_info)
      proceed(product_info)
      @name = product_info[:name]
    end

  end

  user_interface_adaptation()

  module ViewProduct

    adapts_class :ProductView

    def initialize(product_model)
      proceed(product_model)
      @label_name = nil
    end

    def create_product_layout(frame)
      h_frame = proceed(frame)
      @label_name = FXUI::Factory.create_widget(:Label,
                                                h_frame,
                                                @product_model.name,
                                                :opts => LAYOUT_FILL_X|JUSTIFY_LEFT)
      return h_frame
    end

    def update(frame)
      proceed(frame)
      @label_name.text = @product_model.name
    end
  end

end