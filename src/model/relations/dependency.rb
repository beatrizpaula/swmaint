require_relative 'relation'

#
# Class representing a generic dependency.
#
# Author: Benoît Duhoux
# Date: 2018
#
class Dependency < Relation

	attr_reader :source

	def initialize(nodes, source)
		super(nodes)
		@source = source
	end

end