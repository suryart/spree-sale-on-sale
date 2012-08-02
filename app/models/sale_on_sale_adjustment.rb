class SaleOnSaleAdjustment < ActiveRecord::Base
  belongs_to :sale_on_sale
  belongs_to :order
  belongs_to :product
  belongs_to :line_item

  validates :sale_on_sale_id, :presence => true
  validates :order_id, :presence => true
  validates :product_id, :presence => true

  before_destroy :update_order

  def product_included?
    order.products.map(&:id).include?(product_id)
  end

  def update_order
    adjustments = SaleOnSaleAdjustment.where(:order_id => order_id)
    adjustment_total = adjustments.map(&:amount).sum
    order.update_attributes(:adjustment_total => -adjustment_total, :total => (@order.total - adjustment_total), :item_total => products.map(&:price).sum)
  end
end
