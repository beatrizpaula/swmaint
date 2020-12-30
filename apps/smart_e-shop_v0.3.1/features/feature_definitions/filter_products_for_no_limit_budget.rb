#
# Feature to filter the products having no limit budget
#
# Author: Benoît Duhoux
# Date: 2020
#
module FilterProductsForNoLimitBudget

  behaviour_adaptation()

  module Behaviour

    adapts_class :CatalogueModel

    set_prologue :run_filters

    def filter_products()
      products = proceed()
      return filter_by_price(products)
    end

    def filter_by_price(products)
      return products
    end

  end

end