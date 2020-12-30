APP_LOCATION = File.dirname($PROGRAM_NAME)

require_relative 'fbco_object'

require "#{APP_LOCATION}/../../src/code_execution_at_launch_time"
Dir["#{APP_LOCATION}/skeleton/*.rb"].each { |file| require file }
require "#{APP_LOCATION}/contexts/context_declarations"
require "#{APP_LOCATION}/features/feature_declarations"
require "#{APP_LOCATION}/mapping/mapping_declarations"

require_relative 'utils/context_simulator_communication'

module Bootstrap

  class << self

    def init_application()
      @bootstrap_done = false

      AppContextDeclaration.instance
      AppFeatureDeclaration.instance
      AppMappingDeclaration.instance

      ContextDefinition.instance.activate_mandatory_contexts_at_launch_time()
      ContextDefinition.instance.generate_environment_in_simulator()

      @bootstrap_done = true
    end

    def bootstrap_done?()
      return @bootstrap_done
    end

  end

end

Bootstrap.init_application()