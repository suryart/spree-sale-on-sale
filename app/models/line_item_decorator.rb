LineItem.class_eval do

  def on_promotion?
    variant.product.on_promotion?
  end
  
  def promoted_amount
    variant.product.promoted_amount
  end

  def on_sale_amount
    variant.on_sale_amount
  end
end
