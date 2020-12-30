require_relative 'strategy_in_case_of_mandatory_parent'

class DefaultEntityStrategyInCaseOfMandatoryParent < StrategyInCaseOfMandatoryParent

  def initialize(default_entity)
    @default_entity = default_entity
  end

  def select_default_entity()
    return @default_entity
  end

end