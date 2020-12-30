require_relative 'constraint'

#
# Class representing an or constraint.
# It means that at least one sub-entity must be active if the current entity is active.
#
# Author: Benoît Duhoux
# Date: 2018
#
class Or < Constraint

	def interpret()
		satisfied = false
		@nodes.each { 
			|node|  
			satisfied ||= node.can_be_actived?()
		}
		return satisfied
	end

end