#
# Class representing a relation.
#
# Author: Benoît Duhoux
# Date: 2018
#
class Relation

	attr_reader :nodes

	def initialize(nodes)
		@nodes = nodes
	end

	def sub_relations()
		sub_relations = []
		@nodes.each { 
			|node|  
			sub_relations += node.relations.values()
		}
		return sub_relations
	end

	def to_s
		"#{self.class.name} - #{nodes.map { |e| e.entity.name }}"
	end

end