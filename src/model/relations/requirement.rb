require_relative 'dependency'

#
# Class representing a requirement dependency.
# It means that the source entity can be active if and only if the target entity is active.
#
# Author: Benoît Duhoux
# Date: 2018
#
class Requirement < Dependency

	def interpret()
		target_satisfied = true
		@nodes.each { 
			|node|  
			target_satisfied &&= node.can_be_actived?()
		}
		return target_satisfied
	end

end