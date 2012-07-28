Product.class_eval do
  belongs_to :promotion, :conditions => ["starts_at < :start_time AND expires_at > :end_time", {:start_time => Time.now, :end_time => Time.now}] #"starts_at < '#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}' AND expires_at > '#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}'"
  
  delegate :on_promotion?, :promotion_code, :promotioned_amount, :to => :product_promotion
  
  def product_promotion
    ProductPromotion.new(self)
  end
  
end
