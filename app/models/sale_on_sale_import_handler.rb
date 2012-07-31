class SaleOnSaleImportHandler
	attr_reader :sale_on_sale_import
	require 'csv'

	def initialize(sale_on_sale_import)
		@sale_on_sale_import = sale_on_sale_import
	end

	def upload
		local_file = "#{Rails.root.to_s}/public/{@sale_on_sale_import.attachment_file_name}"
		open(local_file, 'wb') do |file|
		  file << open(@sale_on_sale_import.attachment.url).read
		end
		rows = CSV.read(local_file)
		rows.each do |row|
			sku = row[0]
			promoted_amount = row[1]
			start_date = (row[2].split(" ").last.split(":").size == 2) ? row[2]+":00" : row[2]
			end_date = (row[3].split(" ").last.split(":").size == 2) ?  row[3]+":00" : row[3]
			start_date = (start_date.split(" ").first.split("/").last.size == 2) ?  DateTime.strptime("#{start_date}","%d/%m/%y %H:%M:%S") : DateTime.strptime("#{start_date}","%d/%m/%Y %H:%M:%S")
			end_date = (end_date.split(" ").first.split("/").last.size == 2) ?  DateTime.strptime("#{end_date}","%d/%m/%y %H:%M:%S") : DateTime.strptime("#{end_date}","%d/%m/%Y %H:%M:%S")
			product = Variant.where(:sku => sku).first.try(:product)
			unless product.nil?
				puts "="*100
				promotion_rule = product.promotion_rules.first
				product_group = ProductGroup.find_or_create_by_name("SOS")
				product.product_groups << product_group if product.product_groups.blank?
				if promotion_rule.nil?
					promotion = Promotion.new
					promotion.update_attributes(:code => promotion.gen_code, :description => "Promotion Code for Sale on Sale", :usage_limit => product.variants.map(&:count_on_hand).sum, :combine => false, :match_policy => "any", :name => product.class.to_s, :starts_at => start_date, :expires_at => end_date)
					puts promotion.inspect
					puts "\n \n"
					product.update_attributes(:promoted_amount => promoted_amount, :promotion_id => promotion.id)
					puts product.inspect
					puts "\n \n"
					product.promotion_rules << Promotion::Rules::Product.create(:promotion_id => promotion.id, :user_id => @sale_on_sale_import.user_id, :product_group_id => product_group.id, :type => "Promotion::Rules::Product")
					calculator = promotion.calculator.nil? ? Calculator::PerItem.create(:type => "Calculator::PerItem", :calculable_id => promotion.id, :calculable_type => promotion.class.to_s) : promotion.calculator
					preference = Preference.find_or_create_by_owner_id_and_owner_type_and_name(calculator.id, "Calculator", "amount")
					preference.update_attributes(:value => (product.price-product.promoted_amount))
					puts "-"*100
				else
					calculator = promotion_rule.promotion.calculator
					preference = Preference.where(:owner_id => calculator.id, :owner_type => "Calculator", :name => "amount").first
					preference.update_attributes(:value => (product.price-product.promoted_amount))
				end
			end
		end
	end
end