Order.class_eval do

  has_many :sale_on_sale_adjustments
  
  def eligible_for_sos?
  	products.any? { |product| product.on_promotion? }
  end

  fsm = self.state_machines[:state]
  fsm.after_transition :to => 'complete', :do => :consolidate_sale_on_sale_adjustments

  def consolidate_sale_on_sale_adjustments
    if eligible_for_sos?
      adjustment_total = SaleOnSaleAdjustment.where(:order_id => id).map(&:amount).sum
      update_attributes(:adjustment_total => -adjustment_total, :total => (total - adjustment_total), :item_total => products.map(&:price).sum)
    end
  end

  def process_sale_on_sale
    sale_on_sale_ids = products.map{ |product| product.sale_on_sale_id if product.on_promotion? }.reject { |sale_on_sale_id| sale_on_sale_id.blank? }
    order_sale_on_sale_adjustments = sale_on_sale_adjustments.reject { |adjustment| adjustment.blank? }
    sale_on_sale_ids.each do |sale_on_sale_id|
      product = products.find{ |product| product.sale_on_sale_id == sale_on_sale_id }
      line_item = line_items.map{ |line_item| line_item.product.id == product.id }.reject {|li| li.blank?}.first
      order_sale_on_sale_adjustment = SaleOnSaleAdjustment.find_or_create_by_sale_on_sale_id_and_order_id_and_product_id(sale_on_sale_id, id, product.id)
      order_sale_on_sale_adjustment.update_attributes(:line_item_id => line_item.id, :amount => -product.promotioned_amount, :starts_at => product.sale_on_sale.starts_at, :expires_at => product.sale_on_sale.expires_at)
      sale_on_sale_adjustment = adjustments.where(:source_type => "SaleOnSaleAdjustment", :source_id => order_sale_on_sale_adjustment.id).first
      adjustments.create(:amount => order_sale_on_sale_adjustment.amount, :label => "Coupon (#{order_sale_on_sale_adjustment.sale_on_sale.code})", :source_type => "SaleOnSaleAdjustment", :source_id => order_sale_on_sale_adjustment.id) if sale_on_sale_adjustment.nil?
      order_sale_on_sale_adjustments.each { |adjustment| adjustment.destroy unless sale_on_sale_ids.include?(adjustment.sale_on_sale_id) }
    end
  end
end