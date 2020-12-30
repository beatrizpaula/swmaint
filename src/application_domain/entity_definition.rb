#
# Class representing an entity definition
#
# Author: Benoît Duhoux
# Date: 2018
#
class EntityDefinition

	def set_model_root(model_root)
		@model_root = model_root
	end
	
	def activate(entities)
		return @model_root.activate(entities)
	end

	def deactivate(entities)
		return @model_root.deactivate(entities)
	end

	def toggle(entities)
		return @model_root.toggle(entities)
	end

	def find_entity_by_name(entity_name)
		queue = [@model_root]
		while !queue.empty?()
			node = queue.pop()
			if node.name.eql?(entity_name)
				return node
			else
				node.relations.each do
					|_, relation|
					if relation.is_a?(Constraint)
						queue += relation.nodes
					end
				end
			end
		end
		raise(RuntimeError, "The context \"#{entity_name}\" does not exist. Are you sure you have given the right declared name of the context?")
	end

	def print()
		@model_root.print()
	end

end