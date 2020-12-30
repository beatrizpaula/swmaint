require_relative '../utils/feature_visualiser_communication'

#
# Module allowing to send to the visualization tool information 
# about the (un)selection of features according to contexts
# based on the mapping contexts -> features
#
# Author: Benoît Duhoux
# Date: 2018, 2020
#
module FeatureSelectionProxy

	def feedback_for_feature_visualiser(action, picked_features)
		if picked_features.empty?()
			return
		end

		selected_mapping = MappingDefinition.instance.mapping_from_features(picked_features)
		if selected_mapping.empty?()
			return
		end

		if FeatureVisualiserCommunication.instance.dev_env?()
			FeatureVisualiserCommunication.instance.send_message({
				:component => 'FeatureSelection',
				:action => action,
				:selected_mapping => _selected_mapping_to_js_objects(selected_mapping)
			})
		end
	end

	private 

	def _selected_mapping_to_js_objects(selected_mapping)
		js_objects = []
		selected_mapping.each do
			|contexts, features|  
			js_object = {}
			js_object[:contexts] = contexts.map { |context| context.name }
			js_object[:features] = []
			features.each do
				|feature|
				Module.find_feature_module(feature.name).find_all_sub_modules().each do
					|feature_sub_module|
					feature_to_js = {}
					feature_to_js['feature'] = feature_sub_module.name
					feature_to_js['targeted_class'] = feature_sub_module.symbol_of_targeted_class().to_s()
					js_object[:features] << feature_to_js
				end
			end
			js_objects << js_object
		end
		return js_objects
	end

end