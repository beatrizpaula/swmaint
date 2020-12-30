# Include this file before all the others to be sure that all information are sent to the tool.
require_relative 'options_interpreter'
require_relative '../../src/ui_framework/fxruby_framework/fxruby_objects/fx_ui_manager'
require_relative '../../src/bootstrap'

#
# Script to launch the app
#
if $PROGRAM_NAME == __FILE__
  SmartSystem.run() # TODO use the correct classname
end