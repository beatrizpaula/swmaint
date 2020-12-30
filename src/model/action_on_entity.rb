#
# Class representing an action on a specific entity.
#
# Author: Benoît Duhoux
# Date: 2018
#
class ActionOnEntity
	
	attr_reader :action, :entity

	def initialize(action, entity)
		# Check the action to give feedback
		@action = action
		@entity = entity
	end

	def to_s()
		return "#{@action} - #{entity.name}"
	end

end