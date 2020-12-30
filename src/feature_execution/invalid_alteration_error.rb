#
# Class representing an exception when an alteration cannot updated the code
#
# Author: Benoît Duhoux
# Date: 2017
#
class InvalidAlterationError < StandardError
	
	def initialize(msg)
		super
	end

end