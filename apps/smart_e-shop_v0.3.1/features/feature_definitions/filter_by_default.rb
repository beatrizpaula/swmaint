#
# Feature to add a default behaviour for the filters
#
# Author: Benoît Duhoux
# Date: 2020
#
module FilterByDefault

  behaviour_adaptation()

  module Behaviour

    adapts_class :CatalogueModel

    # Redefine the getter "products" to be able to filter the products
    def products()
      return filter_products()
    end

    def filter_products()
      return @products
    end

    def run_filters()
      self.changed()
      self.notify_observers()
    end

  end

end