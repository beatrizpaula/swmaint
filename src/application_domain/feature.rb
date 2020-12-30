require_relative 'abstract_feature'

#
# Class representing a feature
#
# Author: Benoît Duhoux
# Date: 2018, 2020
#
class Feature < AbstractFeature

	attr_reader :targeted_classes

	def initialize(name, targeted_classes, strategy=AtomicStrategy)
		super(name, strategy)
		@targeted_classes = targeted_classes
	end

	def abstract?()
		return false
	end

	def to_s()
		return "feature '#{name}' for classes {#{@targeted_classes.join(', ')}}"
	end

	def hash()
		return super() ^ @targeted_classes.hash()
	end

	def eql?(feature)
		return super(feature) && @targeted_classes == feature.targeted_classes
	end
	
end