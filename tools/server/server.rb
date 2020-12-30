#
# Script to launch the websocket server and instantiate the different communication channels 
#
# Author: Benoît Duhoux
# Date: 2017-2018
# Original code: https://github.com/shokai/websocket-client-simple/blob/master/sample/echo_server.rb
#

#!/usr/bin/env ruby
require 'eventmachine'
require 'slop'
require 'websocket-eventmachine-server'

require_relative 'channel'

HOSTNAME = 'localhost'

def create_channels()
  channels = []
  opts = Slop.parse() {
    |option|
    option.on('-a', '--all', 'Create all the communication channels for the different tools') do
      channels << Channel.new(:ContextSimulatorCommunication, 7777)
      channels << Channel.new(:FeatureVisualiser, 8888)
      channels << Channel.new(:ContextFeatureModel, 9999)
    end
    option.on('--ContextSimulator', 'Create the communication channel for the ContextSimulator tool') do
      channels << Channel.new(:ContextSimulatorCommunication, 7777)
    end
    option.on('--FeatureVisualiser', 'Create the communication channel for the FeatureVisualiser tool.') do
      channels << Channel.new(:FeatureVisualiser, 8888)
    end
    option.on('--ContextFeatureModel', 'Create the communication channel for the ContextFeatureModel tool') do
      channels << Channel.new(:ContextFeatureModel, 9999)
    end
    option.on('-h', '--help') do
      puts option
      exit
    end
  } 
  return channels
end

EM::run do

  puts "The websocket server was launched."
  @channels = create_channels()

  @channels.each { 
    |c|  
    puts "The channel for the #{c.tool} tool is created."
    WebSocket::EventMachine::Server.start(:host => HOSTNAME, :port => c.port) do 
      |ws|
      ws.onopen() do
        sid = c.channel.subscribe() do 
          |message|
          ws.send(message)
        end
        puts "<#{c.port}:##{sid}> The client ##{sid} is connected on the port #{c.port}."

        ws.onmessage do |msg|
          puts "<#{c.port}:##{sid}> #{msg}"
          c.channel.push("#{msg}")
        end

        ws.onclose() do
          puts "<#{c.port}:##{sid}> The client ##{sid} is disconnected on the port #{c.port}."
          c.channel.unsubscribe(sid)
        end
      end
    end
  }

end