require 'singleton'

require_relative 'tools_communication'

#
# Class allowing to communicate with the feature visualisation tool 
#
# Author: Benoît Duhoux
# Date: 2018
#
class FeatureVisualiserCommunication < ToolsCommunication

	include Singleton

	def initialize()
		super(8888)
	end

end
