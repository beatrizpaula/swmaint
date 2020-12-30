#
# Updating the class Class to add some behaviour
#
# Author: Benoît Duhoux
# Date: 2020
#
class Class

  class << self

    def find_class(classname)
      unless self.const_defined?(classname)
        raise(NameError, "#{classname} is not declared as a class of the skeleton.")
      end
      return self.const_get(classname)
    end

  end

end