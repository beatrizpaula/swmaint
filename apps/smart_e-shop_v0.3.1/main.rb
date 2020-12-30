# Include this file before all the others to be sure that all information are sent to the tool.
require_relative 'options_interpreter'
require_relative '../../src/ui_framework/fxruby_framework/fxruby_objects/fx_ui_manager'
require_relative '../../src/bootstrap'

#
# Script to launch the app
#
# Author: Benoît Duhoux
# Date: 2020
#
if $PROGRAM_NAME == __FILE__
  SmartEShop.run()
end