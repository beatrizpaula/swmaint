#
# Feature to filter the products having a budget lower than a price of 250
#
# Author: Benoît Duhoux
# Date: 2020
#
module FilterProductsForLowBudget

  behaviour_adaptation()

  module Behaviour

    adapts_class :CatalogueModel

    set_prologue :run_filters

    def filter_products()
      products = proceed()
      return filter_by_price(products)
    end

    def filter_by_price(products)
      return products.select() do
        |product|
        product.price < 250
      end
    end

  end

end