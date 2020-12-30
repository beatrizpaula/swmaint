require 'singleton'

require_relative 'tools_communication'

#
# Class allowing to communicate with the context-feature-model visualition tool 
#
# Author: Benoît Duhoux
# Date: 2018
#
class ContextFeatureModelCommunication < ToolsCommunication

	include Singleton

	def initialize()
		super(9999)
	end

end
