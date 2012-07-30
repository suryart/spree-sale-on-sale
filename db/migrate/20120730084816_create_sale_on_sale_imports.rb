class CreateSaleOnSaleImports < ActiveRecord::Migration
  def self.up
    create_table :sale_on_sale_imports do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :sale_on_sale_imports
  end
end
