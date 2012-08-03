OrdersController.class_eval do
  before_filter :check_sos_promotion, :only => [:edit, :update]

  def check_sos_promotion
    @order.process_sale_on_sale if @order.try(:eligible_for_sos?)
  end
end