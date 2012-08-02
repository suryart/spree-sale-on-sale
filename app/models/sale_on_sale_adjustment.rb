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
    adjustment = Adjustment.find_by_source_id_and_source_type(id, "SaleOnSaleAdjustment")
    adjustment.destroy unless adjustment.nil?
  end
end
