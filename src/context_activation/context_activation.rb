require 'singleton'

require_relative 'context_activation_proxy'
require_relative '../application_domain/context_definition'
require_relative '../feature_selection/feature_selection'

#
# Class representing the behaviour of the context activation component
#
# Author: Benoît Duhoux
# Date: 2018
#
class ContextActivation

	include ContextActivationProxy
	include Singleton

	def activate(*contexts)
		activated_contexts = ContextDefinition.instance.activate(contexts)
		feedback_for_feature_visualiser(:activate, activated_contexts)
		FeatureSelection.instance.select_changes({:activated => activated_contexts})
	end

	def deactivate(*contexts)
		deactivated_contexts = ContextDefinition.instance.deactivate(contexts)
		feedback_for_feature_visualiser(:deactivate, deactivated_contexts)
		FeatureSelection.instance.select_changes({:deactivated => deactivated_contexts})
	end

	def toggle(actions_on_contexts)
		new_actions_on_contexts = ContextDefinition.instance.toggle(actions_on_contexts)
    to_select = _prepare_selection(new_actions_on_contexts)
    to_select.each do
      |action, contexts|
      feedback_for_feature_visualiser(action, contexts)
    end
    FeatureSelection.instance.select_changes({
                                                 :activated => to_select[:activate],
                                                 :deactivated => to_select[:deactivate],
                                             })
  end

  private

  def _prepare_selection(actions_on_contexts)
    concerned_contexts = {
        :activate => [],
        :deactivate => []
    }
    actions_on_contexts.each do
      |action_on_context|
      concerned_contexts[action_on_context.action.to_sym] << action_on_context.entity
    end
    return concerned_contexts
  end

end