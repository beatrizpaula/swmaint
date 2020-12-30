require_relative '../utils/feature_visualiser_communication'

#
# Module allowing to send to the visualization tool information 
# about the (de)activations of contexts
#
# Author: Benoît Duhoux
# Date: 2018
#
module ContextActivationProxy

	def feedback_for_feature_visualiser(action, toggled_contexts)
		if FeatureVisualiserCommunication.instance.dev_env?()
			FeatureVisualiserCommunication.instance.send_message({
				:component => 'ContextActivation',
				:action => action,
				:contexts => toggled_contexts.map { |context| context.name } 
			})
		end
	end

end