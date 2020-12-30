require_relative 'class'

module CodeExecution

  def run_code_of_features(code_identifier, global_features)
    global_features.each do
      |feature|
      global_feature_module = Module.find_feature_module(feature.name)
      global_feature_module.find_all_sub_modules().each do
        |feature_sub_module|
        unless feature_sub_module.send(code_identifier).nil?()
          targeted_class = Class.find_class(feature_sub_module.symbol_of_targeted_class())
          # concerned_instances = ObjectSpace.each_object(targeted_class)
          concerned_instances = FBCOObjectSpace.instance.get_objects(targeted_class)
          concerned_instances.each do
            |instance|
            _run_code(code_identifier, instance, feature_sub_module)
          end
        end
      end
    end

  end

  protected

  def _run_code(code_identifier, instance, feature_module)
    methods = feature_module.send(code_identifier)
    methods.each do
      |method|
      instance.send(method)
    end
  end

end