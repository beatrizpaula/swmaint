require 'singleton'

class FBCOObjectSpace

  class << self

    def new()
      instance = super()
      instance.init_objectspace()
      return instance
    end

  end

  include Singleton

  def init_objectspace()
    @objectspace = {}
  end

  def add_object(object)
    klass = object.class
    unless @objectspace.key?(klass)
      @objectspace[klass] = [object]
    else
      @objectspace[klass] << object
    end
  end

  def get_objects(klass)
    return @objectspace[klass]
  end

  def remove_object(object)
    klass = object.class
    if @objectspace.key?(klass)
      return @objectspace[klass].delete(object)
    end
    return nil
  end

end