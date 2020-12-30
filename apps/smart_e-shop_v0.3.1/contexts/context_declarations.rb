require 'singleton'

require_relative '../../../src/application_domain/abstract_context'
require_relative '../../../src/application_domain/context'
require_relative '../../../src/application_domain/context_declaration'

#
# Class declaring the contexts of the app
#
# Author: Benoît Duhoux
# Date: 2020
#
class AppContextDeclaration < ContextDeclaration

	include Singleton

	def initialize()
		super()

		_define_device_context()
		_define_budget_context()

		@root_context.add_relation(:Mandatory, [@device_context])
		@root_context.add_relation(:Optional, [@budget_context])
	end

	private

	def _define_device_context()
		@device_context = AbstractContext.new('Device')
		@desktop_context = Context.new('Desktop')
		@smartphone_context = Context.new('Smartphone')
		@device_context.strategy_ico_mandatory_parent = DefaultEntityStrategyInCaseOfMandatoryParent.new(@desktop_context)
		@device_context.add_relation(:Alternative, [@desktop_context, @smartphone_context])
	end

	def _define_budget_context()
		@budget_context = AbstractContext.new('Budget')
		@low_budget_context = Context.new('LowBudget')
		@medium_budget_context = Context.new('MediumBudget')
		@high_budget_context = Context.new('HighBudget')
		@budget_context.add_relation(:Alternative, [@low_budget_context, @medium_budget_context, @high_budget_context])
	end

end