class ProductPromotion
  attr_reader :product
  
  def initialize(product)
    @product = product
  end
  
  def on_promotion?
    (@product.promoted_amount.blank? || @product.promotion_id.blank? || @product.promotion.blank? ||  !(@product.promotion.is_active?)) ? false : true
  end
  
  def promotion_code
    @product.promotion.code
  end
  
  def promotioned_amount
    @product.promotion.calculator.preferences["amount"]
  end
  
end
