class SaleOnSale < ActiveRecord::Base
  has_one :product
  validates :amount, :presence => true, :numericality => true
  
  def gen_code
    rand(9999).to_s+"SOS"+rand(9999).to_s
  end
end
