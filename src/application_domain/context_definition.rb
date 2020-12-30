require 'singleton'

require_relative 'context'
require_relative 'context_simulator_proxy'
require_relative 'entity_definition'

#
# Class representing a context definition
#
# Author: Benoît Duhoux
# Date: 2018
#
class ContextDefinition < EntityDefinition

	include Singleton
	include ContextSimulatorProxy

	def set_model_root(model_root)
		super(model_root)
		# TODO check if it is neede to put the counter of the root at 1 by default
		# activate([@model_root])
	end

	def activate_mandatory_contexts_at_launch_time()
		mandatory_context_leaves = _find_mandatory_context_leaves()
		if !mandatory_context_leaves.empty?()
			# '*' translates the array in a list of arguments
			ContextActivation.instance.activate(*mandatory_context_leaves)
		end
	end

	def generate_environment_in_simulator()
		self.generate_environment(@model_root)
	end

	private

	def _find_mandatory_context_leaves()
		mandatory_leaves = []
		queue = [@model_root]

		while not queue.empty?()
			node = queue.pop()
			# Using the DFS algorithm to ensure the right context has priority on the left context
			# Need of this DFS algorithm to be sure the strategies do not take advantage on some mandatory contexts
			# In the case of the COP calculator, the language has precedence on the mode
			# but the associated features of the context language are based on the features of the basic mode.
			if node.leaf?()
				mandatory_leaves << node
			elsif !node.strategy_ico_mandatory_parent.nil?()
				mandatory_leaves << node.strategy_ico_mandatory_parent.select_default_entity()
			else
				mandatory_children = node.mandatory_children()
				queue += mandatory_children
			end
		end

		return mandatory_leaves
	end

end