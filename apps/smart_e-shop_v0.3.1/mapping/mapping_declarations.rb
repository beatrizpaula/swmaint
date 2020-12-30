require 'singleton'

require_relative '../../../src/application_domain/mapping_declaration'

#
# Class declaring the mapping of the app
#
# Author: Benoît Duhoux
# Date: 2020
#
class AppMappingDeclaration < MappingDeclaration

	include Singleton

	def initialize()
		@mapping = {
			[
				AppContextDeclaration.instance.desktop_context()
			] =>
			[
				AppFeatureDeclaration.instance.listing_products_feature(),
				AppFeatureDeclaration.instance.display_complex_catalogue_layout_feature(),
				AppFeatureDeclaration.instance.display_product_name_feature(),
				AppFeatureDeclaration.instance.display_product_description_feature(),
				AppFeatureDeclaration.instance.display_product_price_feature()
			],
			[
				AppContextDeclaration.instance.smartphone_context()
			] =>
			[
				AppFeatureDeclaration.instance.listing_products_feature(),
				AppFeatureDeclaration.instance.display_simple_catalogue_layout_feature(),
				AppFeatureDeclaration.instance.display_product_name_feature(),
				AppFeatureDeclaration.instance.display_product_price_feature(),
			],
			[
        AppContextDeclaration.instance.low_budget_context()
			] =>
			[
        AppFeatureDeclaration.instance.filter_products_by_default_feature(),
        AppFeatureDeclaration.instance.filter_products_for_low_budget_feature()
			],
			[
				AppContextDeclaration.instance.medium_budget_context()
			] =>
			[
				AppFeatureDeclaration.instance.filter_products_by_default_feature(),
				AppFeatureDeclaration.instance.filter_products_for_medium_budget_feature()
			],
      [
        AppContextDeclaration.instance.high_budget_context()
      ] =>
      [
        AppFeatureDeclaration.instance.filter_products_by_default_feature(),
        AppFeatureDeclaration.instance.filter_products_for_no_limit_budget_feature()
      ]
		}
	end

end