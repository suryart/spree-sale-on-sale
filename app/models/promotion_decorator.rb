Promotion.class_eval do
  scope :sale_on_sale, where("code like :code AND name = :name", {:code => "%SOS%", :name => "Product"})
  scope :active, where("starts_at < :start_time AND expires_at > :end_time", {:start_time => Time.now, :end_time => Time.now})
  
  def is_active?
  	(starts_at < Time.now && expires_at > Time.now)
  end
end
