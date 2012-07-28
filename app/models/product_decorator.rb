Product.class_eval do
  belongs_to :promotion
  
  delegate :on_promotion?, :promotion_code, :promotioned_amount, :to => :product_promotion
  
  def product_promotion
    ProductPromotion.new(self)
  end
  
end
