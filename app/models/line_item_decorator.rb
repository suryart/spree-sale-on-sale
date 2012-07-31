LineItem.class_eval do

	def on_promotion?
		variant.product.on_promotion?
	end
end