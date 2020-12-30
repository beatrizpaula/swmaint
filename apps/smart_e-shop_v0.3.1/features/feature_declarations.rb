require 'singleton'

require_relative '../../../src/module'
require_relative '../../../src/object'
require_relative '../../../src/application_domain/abstract_feature'
require_relative '../../../src/application_domain/feature'
require_relative '../../../src/application_domain/feature_declaration'
Dir[File.dirname(__FILE__) + "/feature_definitions/*.rb"].each { |file| require file }

#
# Class declaring the features of the app
#
# Author: Benoît Duhoux
# Date: 2020
#
class AppFeatureDeclaration < FeatureDeclaration

	include Singleton

	def initialize()
		super()

		_define_features_about_catalogue()
		_define_features_about_product_information()
		_define_features_about_filters()

		@root_feature.add_relation(:Mandatory,
															 [@display_catalogue_feature, @display_product_information_feature])
		@root_feature.add_relation(:Optional, [@filter_products_feature])
	end

	private

	def _define_features_about_catalogue()
		@display_catalogue_feature = AbstractFeature.new('DisplayCatalogue')

		@listing_products_feature = Feature.new('ListingProducts', ['CatalogueModel'])

		@display_catalogue_layout_feature = AbstractFeature.new('DisplayCatalogueLayout')
		@display_simple_catalogue_layout_feature = Feature.new('DisplaySimpleCatalogueLayout', ['SmartEShop', 'CatalogueView', 'ProductView'])
		@display_complex_catalogue_layout_feature = Feature.new('DisplayComplexCatalogueLayout', ['SmartEShop', 'CatalogueView', 'ProductView'])
		@display_catalogue_layout_feature.add_relation(:Alternative,
																									 [@display_simple_catalogue_layout_feature, @display_complex_catalogue_layout_feature])

		@display_catalogue_feature.add_relation(:Mandatory, [@listing_products_feature, @display_catalogue_layout_feature])
	end

	def _define_features_about_product_information()
		@display_product_information_feature = AbstractFeature.new('DisplayProductInformation')
		@display_product_name_feature = Feature.new('DisplayProductName', ['ProductModel', 'ProductView'])
		@display_product_price_feature = Feature.new('DisplayProductPrice', ['ProductModel', 'ProductView'])
		@display_product_description_feature = Feature.new('DisplayProductDescription', ['ProductModel', 'ProductView'])
		@display_product_information_feature.add_relation(:Mandatory,
																											[@display_product_name_feature, @display_product_price_feature])
		@display_product_information_feature.add_relation(:Optional, [@display_product_description_feature])
	end

	def _define_features_about_filters()
		@filter_products_feature = AbstractFeature.new('FilterProducts')

		@filter_products_by_default_feature = Feature.new('FilterByDefault', ['CatalogueModel'])

		@filter_products_by_feature = AbstractFeature.new('FilterProductsBy')

		@filter_products_by_price_feature = AbstractFeature.new('FilterProductsByPrice')
		@filter_products_for_low_budget_feature = Feature.new('FilterProductsForLowBudget', ['CatalogueModel'])
		@filter_products_for_medium_budget_feature = Feature.new('FilterProductsForMediumBudget', ['CatalogueModel'])
		@filter_products_for_no_limit_budget_feature = Feature.new('FilterProductsForNoLimitBudget', ['CatalogueModel'])
		@filter_products_by_price_feature.add_relation(:Alternative,
																									 [	@filter_products_for_low_budget_feature,
																														@filter_products_for_medium_budget_feature,
																													 	@filter_products_for_no_limit_budget_feature])

		@filter_products_by_feature.add_relation(:Or, [@filter_products_by_price_feature])

		@filter_products_feature.add_relation(:Mandatory, [@filter_products_by_default_feature])
		@filter_products_feature.add_relation(:Optional, [@filter_products_by_feature])
	end

end