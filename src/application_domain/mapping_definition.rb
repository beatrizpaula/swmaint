require 'singleton'
require_relative '../model/modelling_proxy'

#
# Class representing the mapping between the contexts and the features
# The mapping follows the structure: {[:context] => [:feature]}
#
# Author: Benoît Duhoux
# Date: 2018
#
class MappingDefinition

	include Singleton
	include ModellingProxy

	def initialize()
		@contexts_features ||= {}
		@contexts_features.compare_by_identity()
	end

	def set_mapping(mapping)
		@contexts_features = mapping
		@contexts_features.compare_by_identity()
		feedback_for_tool(:mapping, mapping)
	end

	def features_from_context(context)
		features = []
		@contexts_features.each { 
			|key, value|  
			if key.include?(context) &&
				 	_combination_active?(key - [context])
				features |= value
			end
		}
		return features
	end

	def mapping_from_features(picked_features)
		mapping = {}
		@contexts_features.each { 
			|contexts, features|  
			if (features - picked_features).empty?()
				mapping[contexts] = features
			end
		}
		return mapping
	end

	private

	def _combination_active?(contexts)
		contexts.each { 
			|context|  
			if !context.active?()
				return false
			end
		}
		return true
	end

end