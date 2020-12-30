require_relative 'abstract_feature'
require_relative 'feature_definition'
require_relative 'entity_declaration'

#
# Class representing an abstract feature declaration
#
# Author: Benoît Duhoux
# Date: 2018
#
class FeatureDeclaration < EntityDeclaration

	def initialize()
		@root_feature = AbstractFeature.new('Features')
		FeatureDefinition.instance.set_model_root(@root_feature)
	end

end