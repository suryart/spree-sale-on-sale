class AddAttachmentAttachementToSaleOnSaleImport < ActiveRecord::Migration
  def self.up
    add_column :sale_on_sale_imports, :attachment_file_name, :string
    add_column :sale_on_sale_imports, :attachment_content_type, :string
    add_column :sale_on_sale_imports, :attachment_file_size, :integer
    add_column :sale_on_sale_imports, :attachment_updated_at, :datetime
  end

  def self.down
    remove_column :sale_on_sale_imports, :attachment_file_name
    remove_column :sale_on_sale_imports, :attachment_content_type
    remove_column :sale_on_sale_imports, :attachment_file_size
    remove_column :sale_on_sale_imports, :attachment_updated_at
  end
end
