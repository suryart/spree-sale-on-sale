class ProductPromotion
  attr_reader :product
  
  def initialize(product)
    @product = product
  end
  
  def on_promotion?
    (@product.is_sos? && @product.sale_on_sale_id?) ? @product.sale_on_sale.is_active? : false
  end
  
  def promotion_code
    @product.sale_on_sale.try(:code)
  end
  
  def promotioned_amount
    @product.sale_on_sale.try(:amount)
  end
  
end
