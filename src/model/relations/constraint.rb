require_relative 'relation'

#
# Class representing a generic constraint.
#
# Author: Benoît Duhoux
# Date: 2018
#
class Constraint < Relation

	def initialize(nodes)
		super(nodes)
	end

	def sub_relations()
		sub_relations = []
		@nodes.each { 
			|node|  
			if node.can_be_actived?()
				sub_relations += node.relations.values()
			end
		}
		return sub_relations
	end

end