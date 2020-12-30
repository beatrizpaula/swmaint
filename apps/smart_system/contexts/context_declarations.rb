require 'singleton'

require_relative '../../../src/application_domain/abstract_context'
require_relative '../../../src/application_domain/context'
require_relative '../../../src/application_domain/context_declaration'

#
# Class declaring the contexts of the app
#
class AppContextDeclaration < ContextDeclaration

	include Singleton

	def initialize()
		super()
		# TODO
	end

end