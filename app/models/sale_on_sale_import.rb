class SaleOnSaleImport < ActiveRecord::Base
  belongs_to :user
  validates :attachment, :presence => true
  has_attached_file :attachment, :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", :path => "sale_on_sale_imports/attachments/:id/:style/:basename.:extension", :url => "/assets/sale_on_sale_import/:id/:style/:basename.:extension",	:storage => :s3
  
  delegate :upload, :to => :upload_handler

  def upload_handler
    SaleOnSaleImportHandler.new(self)
  end
  
end
