#
# Module representing an activatable behaviour in a transactional system.
#
# Author: Benoît Duhoux
# Date: 2018
#
module Activatable

	attr_reader :committed_counter, :pending_counter

	def initialize()
		super()
		@pending_counter = 0
		@committed_counter = 0
	end

	def can_be_actived?()
		@pending_counter > 0
	end

	def active?()
		@committed_counter > 0
	end

	def act()
		@pending_counter = @pending_counter + 1
	end

	def deact()
		if @pending_counter <= 0
			raise RuntimeError,
				'You cannot deactivate a unactive context or feature.'
		else 
			@pending_counter = @pending_counter - 1
		end
	end

	def commit()
		@committed_counter = @pending_counter
	end

	def rollback()
		@pending_counter = @committed_counter
	end
end