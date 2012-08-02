CheckoutController.class_eval do
  before_filter :check_sos_promotion

  def check_sos_promotion
  	if ((params["state"] == "address") || (params["state"] == "payment") || (params["state"] == "order_summary"))
      @order.process_sale_on_sale if @order.eligible_for_sos?
  	end
  end
end