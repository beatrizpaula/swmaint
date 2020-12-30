require_relative 'action_on_entity'
require_relative 'activatable'
require_relative 'invalid_model_error'
require_relative 'modelling_proxy'
require_relative 'strategies/atomic_strategy'
Dir[File.dirname(__FILE__) + "/relations/*.rb"].each { |file| require file }

#
# Module representing a node
#
# Author: Benoît Duhoux
# Date: 2018
#
module Node

  include Activatable
  include ModellingProxy

  attr_reader :relations
	attr_accessor :parent

	def initialize(strategy)
		super()
		@parent = nil
		@relations = {}
		@strategy = strategy.new(self)
	end

	def add_relation(type, targets)
		relation_class = Object.const_get(type)
		relation = nil
		if relation_class < Constraint
			relation = relation_class.new(targets)
			_link_relation_to_parent(targets)
		else
			relation = relation_class.new(targets, self)
		end
		@relations[type] = relation
		feedback_for_tool(:relations, [self, targets, type, relation.is_a?(Constraint)])
	end

	def mandatory_children()
		if @relations[:Mandatory]
			return @relations[:Mandatory].nodes
		end
		return []
	end

	def root?()
		@parent.nil?()
	end

	def leaf?()
		return @relations.empty?()
	end

	def deepest_abstract?()
		if self.root?()
			return false
		end

		if self.leaf?()
			return false
		end

		@relations.each do
			|_, relation|
			relation.nodes.each do
				|node|
				if !node.leaf?()
					return false
				end
			end
		end

		return true
	end

	def activate(entities)
		return @strategy.activate(entities)
	end

	def deactivate(entities)
		return @strategy.deactivate(entities)
	end
	
	def toggle(actions_on_entities)
		return @strategy.toggle(actions_on_entities)
	end

	def satisfy?()
		return @strategy.satisfy?()
	end

	def commit_nodes(entities)
		# The method clone() creates a simple clone without cloning all the underlying structures.
		# There is no need to create a full clone.
		# Here, the idea is to protect the list given in parameter because we remove
		queue = entities.clone()
		while not queue.empty?()
			node = queue.shift()
			node.commit()
			if not node.root?()
				queue << node.parent
			end
		end
	end

	def rollback_nodes(entities)
		# The method clone() creates a simple clone without cloning all the underlying structures.
		# There is no need to create a full clone.
		# Here, the idea is to protect the list given in parameter because we remove
		queue = entities.clone()
		while not queue.empty?()
			node = queue.shift()
			node.rollback()
			if not node.root?()
				queue << node.parent
			end
		end
	end

	def print()
		queue = [self]
		visited = []
		while not queue.empty?
			node = queue.shift()
			if not visited.include?(node)
				puts "#{node.name} (# of activation: #{node.committed_counter})"
				visited << node
				node.relations.each {
					|_, relation|  
					queue += (relation.nodes - visited)
				}
			end
		end
	end

	def print_pending_status()
		queue = [self]
		visited = []
		while not queue.empty?
			node = queue.shift()
			if not visited.include?(node)
				puts "#{node.name} (# of activation: #{node.pending_counter})"
				visited << node
				node.relations.each {
					|_, relation|  
					queue += (relation.nodes - visited)
				}
			end
		end
	end

	private

	def _link_relation_to_parent(nodes)
		nodes.each { 
			|node|  
			node.parent = self
		}
	end

end