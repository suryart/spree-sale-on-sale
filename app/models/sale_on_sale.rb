class SaleOnSale < ActiveRecord::Base
  has_one :product
  validates :amount, :presence => true, :numericality => true
  scope :active, where("starts_at < :start_time AND expires_at > :end_time", {:start_time => Time.now, :end_time => Time.now})
  
  def gen_code
    rand(9999).to_s+"SOS"+rand(9999).to_s
  end

  def is_active?
    (starts_at < Time.now && expires_at > Time.now)
  end
end
