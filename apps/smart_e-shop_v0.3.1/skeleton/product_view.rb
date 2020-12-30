class ProductView < FBCOObject

  def initialize(product_model)
    @product_model = product_model
    @product_model.add_observer(self)
  end

  def update(frame)
  end

  def create_product_layout(frame)
  end

end