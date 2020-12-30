require 'singleton'

require_relative 'entity_definition'
require_relative '../feature_activation/feature_activation'

#
# Class representing a feature definition
#
# Author: Benoît Duhoux
# Date: 2018
#
class FeatureDefinition < EntityDefinition

	include Singleton

	# We assume all mandatory features intended to be active at the launch time
	# are attached to mandatory contexts (with or without strategies)
	attr_accessor :bootstrapped_features

end