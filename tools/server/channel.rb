#
# Class representing a channel
#
# Author: Benoît Duhoux
# Date: 2018
#
class Channel
	
	attr_reader :channel, :tool, :port

	def initialize(tool, port)
		@channel = EM::Channel.new
		@tool = tool
		@port = port
	end

end