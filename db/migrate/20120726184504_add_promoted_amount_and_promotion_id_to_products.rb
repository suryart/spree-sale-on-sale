class AddPromotedAmountAndPromotionIdToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :promoted_amount, :float
    add_column :products, :promotion_id, :integer
  end

  def self.down
    remove_column :products, :promotion_id
    remove_column :products, :promoted_amount
  end
end
