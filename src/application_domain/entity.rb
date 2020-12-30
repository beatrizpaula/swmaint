Dir[File.dirname(__FILE__) + "/strategies_in_case_of_mandatory_parent/*.rb"].each { |file| require file }
require_relative '../model/node'

#
# Class representing an entity
#
# Author: Benoît Duhoux
# Date: 2018
#
class Entity
	
	attr_reader :name
	attr_accessor :strategy_ico_mandatory_parent

	include Node

	def initialize(name, strategy=AtomicStrategy)
		super(strategy)
		@name = name
		feedback_for_tool(:entity_node, self)
	end

	def abstract?()
		return true
	end

	def hash()
		@name.hash()
	end

	def eql?(entity)
		@name == entity.name
	end
end