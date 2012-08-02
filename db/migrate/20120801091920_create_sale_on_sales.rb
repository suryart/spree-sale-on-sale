class CreateSaleOnSales < ActiveRecord::Migration
  def self.up
    create_table :sale_on_sales do |t|
      t.string :name
      t.text :description
      t.string :code
      t.float :amount
      t.datetime :starts_at
      t.datetime :expires_at

      t.timestamps
    end
  end

  def self.down
    drop_table :sale_on_sales
  end
end
