require 'singleton'

require_relative 'feature_activation_proxy'
require_relative '../application_domain/feature_definition'
require_relative '../feature_execution/feature_execution'

#
# Class representing the behaviour of the feature activation component
#
# Author: Benoît Duhoux
# Date: 2018
#
class FeatureActivation

	include FeatureActivationProxy
	include Singleton

	def activate(*features)
		if not features.empty?()
			activated_features = FeatureDefinition.instance.activate(features)
			feedback_for_feature_visualiser(_convert_to_actions_on_features(activated_features))
			FeatureExecution.instance.execute_activation(activated_features)
		end
	end

	def toggle(features)
		toggled_features = FeatureDefinition.instance.toggle(features)

		if (!Bootstrap.bootstrap_done?() && !toggled_features.empty?())
			FeatureDefinition.instance.bootstrapped_features = toggled_features.map do
				|action_on_entity|
				action_on_entity.entity
			end
		end

		feedback_for_feature_visualiser(toggled_features)
		FeatureExecution.instance.execute(toggled_features)
	end

	private

	def _convert_to_actions_on_features(activated_features)
		actions_on_features = []
		activated_features.each {
				|activated_feature|
			actions_on_features << ActionOnEntity.new(:activate, activated_feature)
		}
		return actions_on_features
	end

end