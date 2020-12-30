require_relative '../utils/feature_visualiser_communication'

#
# Module allowing to send to the visualization tool information 
# about the alterations of the code
#
# Author: Benoît Duhoux
# Date: 2018
#
module FeatureExecutionProxy

	def feedback_for_feature_visualiser(action, feature_sub_module, targeted_class)
		if FeatureVisualiserCommunication.instance.dev_env?
			FeatureVisualiserCommunication.instance.send_message({
				:component => 'FeatureExecution',
				:action => action,
				:classname => targeted_class.name,
				:feature => feature_sub_module.name,
				:superclass => targeted_class.superclass,
				:methods => feature_sub_module.instance_methods(false)
			})
		end
	end

	def error_feedback_for_feature_visualiser(error)
		FeatureVisualiserCommunication.instance.send_message({
			:error => true,
			:message => error
		})
	end

end