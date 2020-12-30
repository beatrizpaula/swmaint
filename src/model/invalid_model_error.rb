#
# Class representing an error when the model is not satisfied
#
# Author: Benoît Duhoux
# Date: 2018
#
class InvalidModelError < StandardError
	
	def initialize(msg)
		super
	end

end