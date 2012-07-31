CheckoutController.class_eval do
  before_filter :check_sos_promotion

  def check_sos_promotion
  	if ((params["state"] == "payment") || (params["state"] == "order_summary"))
  		puts "="*1000+" SURYA "*1000+"="*10000
  		products = @order.line_items.map { |li| li.variant.product }
  		promotion_ids = products.map(&:promotion_id).reject{ |promo_id| promo_id.blank? }
  		adjustment = @order.adjustments.where(:source_type => "Promotion").first
  		if adjustment.nil?
  			promotion_ids.each{ |promo_id| (@order.adjustments << Adjustment.create(:source_type => "Promotion", :source_id => promo_id, :amount => products.find{ |product| product.promotion_id == promo_id }.promotioned_amount, :label => "Coupon (#{products.find{ |product| product.promotion_id == promo_id }.promotion_code})")) }
  		else

  		end
  	end
  end
end