Product.class_eval do
  belongs_to :sale_on_sale

  scope :promoted, where("on_sale_amount IS NOT NULL AND sale_on_sale_id IS NOT NULL")

  delegate :on_promotion?, :promotion_code, :promotioned_amount, :to => :product_promotion

  def product_promotion
    ProductPromotion.new(self)
  end
end
