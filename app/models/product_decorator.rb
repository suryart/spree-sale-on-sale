Product.class_eval do
	scope :promoted, where("promoted_amount is NOT NULL AND promotion_id is NOT NULL")

  belongs_to :promotion #, :conditions => ["starts_at < :start_time AND expires_at > :end_time", {:start_time => Time.now, :end_time => Time.now}]
  
  delegate :on_promotion?, :promotion_code, :promotioned_amount, :to => :product_promotion
  
  def product_promotion
    ProductPromotion.new(self)
  end
  
end
