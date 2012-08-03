Variant.class_eval do

	def on_promotion?
		product.on_promotion?
	end

	def promoted_amount
		product.promoted_amount
	end

  def on_sale_amount
    product.on_sale_amount
  end
end