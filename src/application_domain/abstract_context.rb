require_relative 'entity'

#
# Class representing an abstract context
#
# Author: Benoît Duhoux
# Date: 2018
#
class AbstractContext < Entity

  def initialize(name, strategy=AtomicStrategy)
    super(name, strategy)
  end

end