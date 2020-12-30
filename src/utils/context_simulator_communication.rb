require 'singleton'

require_relative 'tools_communication'
require_relative '../../src/context_activation/context_activation'

#
# Class allowing the developer to interact with the system to (de)activate contexts
# in a context-oriented application
#
# Author: Benoît Duhoux
# Date: 2020
#
class ContextSimulatorCommunication < ToolsCommunication

  include Singleton

  def initialize()
    super(7777)
  end

  def recv_message(msg)
    actions = JSON.parse(msg)
    if actions.has_key?('init')
      # reject the message from the architecture about the initialization of the context simulator
      return
    end

    actions_on_contexts = _generate_actions_on_contexts(actions)
    ContextActivation.instance.toggle(actions_on_contexts)
  end

  private

  def _generate_actions_on_contexts(actions)
    actions_on_contexts = []
    actions.each do
    |action, contexts|
      contexts.each do
      |context_name|
        context = ContextDefinition.instance.find_entity_by_name(context_name)
        actions_on_contexts << ActionOnEntity.new(action, context)
      end
    end
    return actions_on_contexts
  end

end



