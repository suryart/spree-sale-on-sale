CheckoutController.class_eval do
  before_filter :check_sos_promotion

  def check_sos_promotion
  	if ((params["state"] == "payment") || (params["state"] == "order_summary"))
      if @order.eligible_for_sos?
    		puts "="*1000+" SURYA "*1000+"="*10000
    		products = @order.products
    		sale_on_sale_ids = products.map{ |product| product.sale_on_sale_id if product.on_promotion? }.reject { |promo_id| promo_id.blank? }
        order_sale_on_sale_adjustments = @order.sale_on_sale_adjustments.reject { |adjustment| adjustment.blank? }
    		adjustment = order_sale_on_sale_adjustments.first
        sale_on_sale_ids.each do |promo_id|
          product = products.find{ |product| product.sale_on_sale_id == promo_id }
          line_item = @order.line_items.find{ |line_item| line_item.variant.product.id == product.id }
          if adjustment.nil? && !sale_on_sale_ids.blank?
            SaleOnSaleAdjustment.create(:order_id => @order.id, :sale_on_sale_id => promo_id, :product_id => product.id, :line_item_id => line_item.id, :amount => -product.promotioned_amount, :starts_at => product.sale_on_sale.starts_at, :expires_at => product.sale_on_sale.expires_at)
          elsif (!adjustment.nil? && !sale_on_sale_ids.blank?)
            order_sale_on_sale_adjustments << SaleOnSaleAdjustment.create(:order_id => @order.id, :sale_on_sale_id => promo_id, :product_id => product.id, :line_item_id => line_item.id, :amount => -product.promotioned_amount, :starts_at => product.sale_on_sale.starts_at, :expires_at => product.sale_on_sale.expires_at) unless order_sale_on_sale_adjustments.map(&:sale_on_sale_id).include?(promo_id)
            order_sale_on_sale_adjustments.each { |adjustment| adjustment.destroy unless sale_on_sale_ids.include?(adjustment.sale_on_sale_id) }
          else
          end
        end
        # adjustments = SaleOnSaleAdjustment.where(:order_id => order_id)
        # adjustment_total = adjustments.map(&:amount).sum
        # order.update_attributes(:adjustment_total => -adjustment_total, :total => (@order.total - adjustment_total), :item_total => products.map(&:price).sum)
        puts "="*1000+" SURYA "*1000+"="*10000
      end
  	end
  end
end