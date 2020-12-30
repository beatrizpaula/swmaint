require_relative 'code_execution'

module CodeExecutionAtLaunchTime

  include CodeExecution

  def new(args)
    # This method 'new' overrides the traditional behaviour of this method
    # to allow to execute the prologue statement at the launch time for mandatory features.
    # To take benefit of this method, we must include this module in the meta-class of the class (i.e. class << self)
    instance = super(args)
    _run_prologue_of_mandatory_features()
    return instance
  end

  private

  def _run_prologue_of_mandatory_features()
    mandatory_features = FeatureDefinition.instance.bootstrapped_features
    unless mandatory_features.nil?()
      run_code_of_features(:prologue, mandatory_features)
    end
  end

end