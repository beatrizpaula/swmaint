require 'singleton'

require_relative '../../src/utils/tools_communication'

class ContextSimulator < ToolsCommunication

  include Singleton

  def initialize()
    super(7777)
  end

  def send_command(string_command)
    commands = _parse_command(string_command)
    send_message(commands)
  end

  private

  def _parse_command(string_command)
    commands = {}
    parts_of_command = string_command.split(';')
    parts_of_command.each do
      |part_of_command|
      action, contexts = part_of_command.split(':')
      action = action.strip()
      if contexts.nil?()
        raise(RuntimeError, 'The format of the provided command is not respected.')
      end
      contexts = contexts.split(',').map(&:strip)
      if ['activate', 'deactivate'].include?(action) &&
          !contexts.empty?()
        commands[action.to_sym()] = contexts
      else
        raise(RuntimeError, 'The format of the provided command is not respected.')
      end
    end
    return commands
  end

end

if $PROGRAM_NAME == __FILE__
  puts "The commands must follow the following format:"
  puts "activate: context_name, context_name; deactivate: context_name, context_name"

  current_command = ''
  while !['exit', 'quit'].include?(current_command)
    puts "Enter a new command:"
    current_command = STDIN.gets().chomp()
    ContextSimulator.instance.send_command(current_command)
  end
end
