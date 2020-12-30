require 'singleton'

require_relative '../../../src/application_domain/mapping_declaration'

#
# Class declaring the mapping of the app
#
class AppMappingDeclaration < MappingDeclaration

	include Singleton

	def initialize()
		@mapping = {
				# TODO
		}
	end

end