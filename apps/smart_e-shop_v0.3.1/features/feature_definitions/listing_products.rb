#
# Feature to list the products from a behaviour point of view
#
# Author: Benoît Duhoux
# Date: 2020
#
module ListingProducts

  behaviour_adaptation()

  module Behaviour

    adapts_class :CatalogueModel

    attr_reader :products

    def initialize()
      @products = []
    end

    def add_product(product)
      if !@products.include?(product)
        @products.push(product)
      end
    end

    def remove_product(product)
      if @product.include?(product)
        @product.delete(product)
      end
    end

  end

end