class AddIsSosandSaleOnSaleIdAndOnSaleAmountToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :is_sos, :boolean
    add_column :products, :sale_on_sale_id, :integer
    add_column :products, :on_sale_amount, :float
  end

  def self.down
    remove_column :products, :on_sale_amount
    remove_column :products, :sale_on_sale_id
    remove_column :products, :is_sos
  end
end
