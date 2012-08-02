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
			promoted_amount = BigDecimal.new(row[1])
			start_date = (row[2].split(" ").last.split(":").size == 2) ? row[2]+":00" : row[2]
			end_date = (row[3].split(" ").last.split(":").size == 2) ?  row[3]+":00" : row[3]
			start_date = (start_date.split(" ").first.split("/").last.size == 2) ?  DateTime.strptime("#{start_date}","%d/%m/%y %H:%M:%S") : DateTime.strptime("#{start_date}","%d/%m/%Y %H:%M:%S")
			end_date = (end_date.split(" ").first.split("/").last.size == 2) ?  DateTime.strptime("#{end_date}","%d/%m/%y %H:%M:%S") : DateTime.strptime("#{end_date}","%d/%m/%Y %H:%M:%S")
			product = Variant.where(:sku => sku).first.try(:product)
			unless product.nil?
				sale_on_sale = SaleOnSale.new(:name => "Sale on Sale", :description => "Sale on Sale..", :amount => (product.price-promoted_amount), :starts_at => start_date, :expires_at => end_date)
				sale_on_sale.code = sale_on_sale.gen_code
				sale_on_sale.save
				product.update_attributes(:is_sos => true, :sale_on_sale_id => sale_on_sale.id, :on_sale_amount => promoted_amount)
			end
		end
	end
end