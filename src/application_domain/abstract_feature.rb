require_relative 'entity'

#
# Class representing an abstract feature
#
# Author: Benoît Duhoux
# Date: 2018
#
class AbstractFeature < Entity

  def initialize(name, strategy=AtomicStrategy)
    super(name, strategy)
  end

end