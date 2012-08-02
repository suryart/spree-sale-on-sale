class CreateSaleOnSaleAdjustments < ActiveRecord::Migration
  def self.up
    create_table :sale_on_sale_adjustments do |t|
      t.integer :sale_on_sale_id
      t.integer :order_id
      t.integer :product_id
      t.integer :line_item_id
      t.float :amount
      t.datetime :starts_at
      t.datetime :expires_at

      t.timestamps
    end
  end

  def self.down
    drop_table :sale_on_sale_adjustments
  end
end
