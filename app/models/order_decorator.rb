Order.class_eval do

  has_many :sale_on_sale_adjustments
  
  def eligible_for_sos?
  	products.any? { |product| product.on_promotion? }
  end

  fsm = self.state_machines[:state]
  fsm.after_transition :to => 'complete', :do => :consolidate_sale_on_sale_adjustments

  def consolidate_sale_on_sale_adjustments
    if eligible_for_sos?
      adjustments = SaleOnSaleAdjustment.where(:order_id => id)
      adjustment_total = adjustments.map(&:amount).sum
      update_attributes(:adjustment_total => -adjustment_total, :total => (total - adjustment_total), :item_total => products.map(&:price).sum)
    end
  end
end