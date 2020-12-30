#
# Feature to display the product price
#
# Author: Benoît Duhoux
# Date: 2020
#
module DisplayProductPrice

  behaviour_adaptation()

  module Behaviour

    adapts_class :ProductModel

    attr_accessor :price

    def initialize(product_info)
      proceed(product_info)
      @price = product_info[:price]
    end

  end

  user_interface_adaptation()

  module ViewProduct

    adapts_class :ProductView

    def initialize(product_model)
      proceed(product_model)
      @label_price = nil
    end

    def create_product_layout(frame)
      h_frame = proceed(frame)
      @label_price = FXUI::Factory.create_widget(:Label,
                                                 h_frame,
                                                 @product_model.price.to_s(),
                                                 :opts => LAYOUT_FILL|JUSTIFY_RIGHT)
      return h_frame
    end

    def update(frame)
      proceed(frame)
      @label_price.text = @product_model.price.to_s()
    end

  end

end