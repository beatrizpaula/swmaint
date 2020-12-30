require_relative 'constraint'

#
# Class representing an optional constraint.
# It means that the sub-entity may be active or not.
#
# Author: Benoît Duhoux
# Date: 2018
#
class Optional < Constraint

	def interpret()
		return true
	end

end