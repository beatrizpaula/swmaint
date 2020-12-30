require_relative 'constraint'

#
# Class representing an alternative constraint.
# It means that exactly one sub-entity must be active if the current entity is active.
#
# Author: Benoît Duhoux
# Date: 2018
#
class Alternative < Constraint

	def interpret
		satisfied_count = 0
		@nodes.each { 
			|node|  
			if node.can_be_actived?()
				satisfied_count += 1
			end
		}
		return satisfied_count == 1
	end

end