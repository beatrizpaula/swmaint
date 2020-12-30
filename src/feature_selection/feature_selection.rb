require 'singleton'

require_relative 'feature_selection_proxy'
require_relative '../application_domain/mapping_definition'
require_relative '../feature_activation/feature_activation'

#
# Class representing the behaviour of the feature selection component
#
# Author: Benoît Duhoux
# Date: 2018
#
class FeatureSelection

	include FeatureSelectionProxy
	include Singleton

	def select_changes(contexts)
		action_on_features = _select_features(contexts)

		FeatureActivation.instance.toggle(action_on_features)
	end

	private

	def _select_features(contexts)
		selection = _features_from_contexts(contexts[:activated])
		unselection = _features_from_contexts(contexts[:deactivated])

		feedback_for_feature_visualiser(:selection, selection)
		features_to_activate = _generate_action_on_features(:activate, selection)

		# We need to reverse otherwise we cannot deactivate the features due to the proceed mechanism
		unselection.reverse!()
		feedback_for_feature_visualiser(:unselection, unselection)
		features_to_deactivate = _generate_action_on_features(:deactivate, unselection)

		return features_to_deactivate + features_to_activate
	end

	def _features_from_contexts(contexts)
		picked_features = []
		if contexts
			contexts.each { 
				|context|  
				picked_features |= MappingDefinition.instance.features_from_context(context)
			}
		end
		return picked_features
	end

	def _generate_action_on_features(action, features)
		action_on_entities = []
		features.each { 
			|feature|  
			action_on_entities << ActionOnEntity.new(action, feature)
		}
		return action_on_entities
	end

end