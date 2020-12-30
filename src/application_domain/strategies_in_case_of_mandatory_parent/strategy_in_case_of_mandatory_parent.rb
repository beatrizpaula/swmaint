class StrategyInCaseOfMandatoryParent

  def select_default_entity()
    raise(NoMethodError, "Your subclass #{self.class} must overwrite this method #{__method__}().")
  end

end