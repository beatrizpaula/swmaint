require_relative 'strategy'

#
# Class representing an atomic strategy.
# This strategy tries to (de)activate all the entities in a same transaction.
#
# Author: Benoît Duhoux
# Date: 2018
#
class AtomicStrategy < Strategy

	def activate(entities)
		entities.each { 
			|entity|  
			_activate_node(entity)
		}

		if satisfy?()
			@model.commit_nodes(entities)
			return entities
		else
			@model.rollback_nodes(entities)
			error = "Unsatisfiable model after trying to activate"
			error += " #{entities.map { |entity| entity.name }}."
			error += " A rollback was executed."
			raise InvalidModelError, error
		end
	end
	
	def deactivate(entities)
		entities.each { 
			|entity|  
			_deactivate_node(entity)
		}

		if satisfy?()
			@model.commit_nodes(entities)
			return entities
		else
			@model.rollback_nodes(entities)
			error = "Unsatisfiable model after trying to deactivate"
			error += " #{entities.map { |entity| entity.name }}."
			error += " A rollback was executed."
			raise InvalidModelError, error
		end
	end
	
	def toggle(actions_on_entities)
		entities = []
		actions_on_entities.each { 
			|action_on_entity|  
			method_name = "_#{action_on_entity.action}_node"
			entity = action_on_entity.entity
			self.send(method_name, entity)
			entities << entity
		}

		if satisfy?()
			@model.commit_nodes(entities)
			return actions_on_entities
		else
			@model.rollback_nodes(entities)
			error = "Unsatisfiable model after trying to ("
			actions_on_entities.each {
				|action_on_entity|  
				error += "[#{action_on_entity.action}: #{action_on_entity.entity.name}]"
			}
			error += ")."
			error += " A rollback was executed."
			raise InvalidModelError, error
		end
	end

	def satisfy?()
		is_satisfied = @model.can_be_actived?()
		queue = @model.relations.values.clone()
		visited = []
		while not queue.empty?
			relation = queue.shift()
			if not visited.include?(relation)
				visited << relation
				is_satisfied &&= relation.interpret()
				queue += relation.sub_relations().clone()
			end
		end
		return is_satisfied
	end

	private 

	def _activate_node(entity_node)
		queue = [entity_node]
		while not queue.empty?()
			node = queue.shift()
			node.act()
			if not node.root?()
				queue << node.parent
			end
			@model.feedback_for_tool(:activation, node)
		end
	end

	def _deactivate_node(entity_node)
		queue = [entity_node]
		while not queue.empty?()
			node = queue.shift()
			node.deact()
			if not node.root?()
				queue << node.parent
			end
			@model.feedback_for_tool(:deactivation, node)
		end
	end

end