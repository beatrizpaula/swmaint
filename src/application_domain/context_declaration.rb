require_relative 'abstract_context'
require_relative 'context_definition'
require_relative 'entity_declaration'

#
# Class representing an abstract context declaration
#
# Author: Benoît Duhoux
# Date: 2018
#
class ContextDeclaration < EntityDeclaration

	def initialize()
		@root_context = AbstractContext.new('Contexts')
		ContextDefinition.instance.set_model_root(@root_context)
	end

end