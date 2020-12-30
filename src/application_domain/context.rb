require_relative 'abstract_context'

#
# Class representing a context
#
# Author: Benoît Duhoux
# Date: 2018
#
class Context < AbstractContext

	def initialize(name, strategy=AtomicStrategy)
		super(name, strategy)
	end

	def abstract?()
		return false
	end

end