#
# Class representing an alteration
#
# Author: Benoît Duhoux
# Date: 2017
#
class Alteration

	attr_reader :feature_name, :method_name, :method_code

	def initialize(feature_name, method_name, method_code)
		@feature_name = feature_name
		@method_name = method_name
		@method_code = method_code
	end

	def to_s
		"Method '#{@method_name}' from feature '#{@feature_name}'"
	end

	def comes_from?(feature_name)
		@feature_name == feature_name
	end

end