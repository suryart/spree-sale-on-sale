Order.class_eval do

  has_many :sale_on_sale_adjustments
  
  def eligible_for_sos?
  	products.any? { |product| product.on_promotion? }
  end

  def process_sale_on_sale
    sale_on_sale_ids = products.map{ |product| product.sale_on_sale_id if product.on_promotion? }.reject { |sale_on_sale_id| sale_on_sale_id.blank? }
    order_sale_on_sale_adjustments = sale_on_sale_adjustments.reject { |adjustment| adjustment.blank? }
    sale_on_sale_ids.each do |sale_on_sale_id|
      product = products.find{ |product| product.sale_on_sale_id == sale_on_sale_id }
      line_item = line_items.map{|li| li }.find{|li| li.product.id == product.id}
      order_sale_on_sale_adjustment = SaleOnSaleAdjustment.find_or_create_by_sale_on_sale_id_and_order_id_and_product_id(sale_on_sale_id, self.id, product.id)
      order_sale_on_sale_adjustment.update_attributes(:line_item_id => line_item.id, :amount => (-product.promotioned_amount)*line_item.quantity, :starts_at => product.sale_on_sale.starts_at, :expires_at => product.sale_on_sale.expires_at)
      sale_on_sale_adjustment = adjustments.where(:source_type => "SaleOnSaleAdjustment", :source_id => order_sale_on_sale_adjustment.id).first
      if sale_on_sale_adjustment.nil?
        adjustments.create(:amount => order_sale_on_sale_adjustment.amount, :label => "Coupon (#{order_sale_on_sale_adjustment.sale_on_sale.code})", :source_type => "SaleOnSaleAdjustment", :source_id => order_sale_on_sale_adjustment.id)
      else
        sale_on_sale_adjustment.update_attributes(:amount => order_sale_on_sale_adjustment.amount)
      end
      order_sale_on_sale_adjustments.each { |adjustment| adjustment.destroy unless sale_on_sale_ids.include?(adjustment.sale_on_sale_id) }
    end
  end
end