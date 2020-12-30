require_relative 'mapping_definition'

#
# Class representing an abstract mapping declaration
#
# Author: Benoît Duhoux
# Date: 2018
#
class MappingDeclaration

	attr_reader :mapping

	class << self

		def new()
			declaration = super()
			MappingDefinition.instance.set_mapping(declaration.mapping())
			return declaration
		end

	end

end