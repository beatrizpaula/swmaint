require_relative 'fbco_object_space'

class FBCOObject < Object

  class << self

    def new(*args)
      instance = super(*args)
      FBCOObjectSpace.instance.add_object(instance)
      return instance
    end

  end

end