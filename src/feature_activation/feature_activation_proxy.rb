require_relative '../model/action_on_entity'
require_relative '../utils/feature_visualiser_communication'

#
# Module allowing to send to the visualization tool information 
# about the (de)activations of features
#
# Author: Benoît Duhoux
# Date: 2018, 2020
#
module FeatureActivationProxy

	def feedback_for_feature_visualiser(toggled_features)
		if FeatureVisualiserCommunication.instance.dev_env?()
			FeatureVisualiserCommunication.instance.send_message({
				:component => 'FeatureActivation',
				:actions_on_features => _actions_on_features_to_js_objects(toggled_features)
			})
		end
	end

	protected

	def _actions_on_features_to_js_objects(toggled_features)
		js_objects = []
		if toggled_features
			toggled_features.each { 
				|toggled_feature|
				Module.find_feature_module(toggled_feature.entity.name).find_all_sub_modules().each do
				|feature_sub_module|
					js_object = {}
					js_object['action'] = toggled_feature.action
					js_object['feature'] = feature_sub_module.name
					js_object['targetedClass'] = feature_sub_module.symbol_of_targeted_class().to_s()
					js_object['methods'] = _get_methods_of(feature_sub_module)
					js_objects << js_object
				end
			}
		end
		return js_objects
	end

	def _get_methods_of(feature_module)
		return feature_module.instance_methods(false)
	end
	
end