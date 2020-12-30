require 'singleton'

require_relative '../../../src/module'
require_relative '../../../src/object'
require_relative '../../../src/application_domain/abstract_feature'
require_relative '../../../src/application_domain/feature'
require_relative '../../../src/application_domain/feature_declaration'
Dir[File.dirname(__FILE__) + "/feature_definitions/*.rb"].each { |file| require file }

#
# Class declaring the features of the app
#
class AppFeatureDeclaration < FeatureDeclaration

	include Singleton

	def initialize()
		super()
		# TODO
	end

end