class SaleOnSaleImport < ActiveRecord::Base
	validate :no_attachment_errors
  has_attached_file :attachment, :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", :path => "attachments/:id/:style/:basename.:extension", :url => "/assets/sale_on_sale_import/:id/:style/:basename.:extension",	:storage => :s3
  
end
