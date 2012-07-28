class ProductPromotion
  attr_reader :product
  
  def initialize(product)
    @product = product
  end
  
  def on_promotion?
    (@product.promoted_amount.blank? || @product.promotion_id.blank? || @product.promotion.blank?) ? false : true
  end
  
  def promotion_code
    # promotion.calculator.preferences["amount"] will give amount
    @product.promotion.code
  end
  
  def promotioned_amount
    @product.promotion.calculator.preferences["amount"]
  end
  
end
