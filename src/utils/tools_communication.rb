require 'json'
require 'websocket-client-simple'

require_relative 'communication'

#
# Generic class for the communication with the different tools
#
# Author: Benoît Duhoux
# Date: 2018
#
class ToolsCommunication

	include Communication
	
	def initialize(port)
		@port = port
		self.connect()
	end

end
