require 'json'
require 'websocket-client-simple'

#
# Trait dedicated to the communication with the visualisation tools
#
# Author: Benoît Duhoux
# Date: 2018
#
module Communication

	def connect()
		if @ws.nil?()
			_create_connection()
			_waiting_opening()
		end
	end

	def send_message(data)
		if !@ws.nil?()
			@ws.send(data.to_json())
		end
	end

	def recv_message(msg)
	end

	def dev_env?()
		return (!ENV['APP_ENVIRONMENT'].nil?() and ENV['APP_ENVIRONMENT'].intern() == :dev)
	end

	private

	def _create_connection(communication_tool=self)
		begin
			@ws = WebSocket::Client::Simple.connect("ws://localhost:#{@port}") do
				|ws|

				ws.on(:message) do |msg|
					communication_tool.recv_message(msg.data)
				end

				ws.on(:close) do |e|
				  puts e
				  exit 1
				end

				ws.on(:error) do |e|
				  puts e
				end
			end
		rescue Exception => e
			# Do nothing to avoid a crash
		end
	end

	def _waiting_opening()
		if @ws.nil?()
			return
		end

		while !@ws.open?()
			sleep(1)
		end
	end

end
