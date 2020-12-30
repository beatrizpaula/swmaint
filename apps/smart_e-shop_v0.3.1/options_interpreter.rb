require 'slop'

#
# Script to define the environment in which the application is launched
#
# Author: Benoît Duhoux
# Date: 2020
#

opts = Slop.parse() {
  |option|
  option.on('-d', '--mode=dev', 'Set the dev environment') do
    ENV['APP_ENVIRONMENT'] ||= 'dev'
  end
  option.on('-h', '--help') do
    puts option
    exit
  end
}
ENV['APP_ENVIRONMENT'] ||= 'proto'
puts "You are in the #{ENV['APP_ENVIRONMENT']} mode..."