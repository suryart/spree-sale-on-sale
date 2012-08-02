class SalePromotionsController < ApplicationController
  before_filter :authenticate_user_role
  layout "sale_on_sale"
  
  def authenticate_user_role
    redirect_to root_path if (current_user.nil? ? true : !current_user.roles.map(&:name).include?("cs"))
  end

  def index
    @sale_on_sale_import = SaleOnSaleImport.new
    @sale_on_sales = SaleOnSale.includes(:product).active.reverse.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
      format.xml
    end
  end

  def all
    @sale_on_sale_import = SaleOnSaleImport.new
    @sale_on_sales = SaleOnSale.includes(:product).all.reverse.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  def show
    @product = Product.find_by_permalink(params[:id])
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  def edit
    @product = Product.find_by_permalink(params[:id])
    respond_to do |format|
      format.html
      format.xml
    end
  end

  def update
    product = Product.find_by_permalink(params[:id])
    respond_to do |format|
      if product.update_attributes(params[:product])
        sale_on_sale = SaleOnSale.find(product.sale_on_sale_id)
        sale_on_sale.update_attributes(:amount => (product.price-product.on_sale_amount))
        format.html { redirect_to :back, :notice => "#{product.name}'s promoted amount has been updated successfully!" }
        format.xml
      else
        format.html { redirect_to :back, :alert => "#{product.name}'s promoted amount couldn't be updated. Here is the error: #{product.errors}" }
      end
    end
  end

  def destroy
   product=Product.find_by_permalink(params[:id])
    puts "parameters: #{params[:id]}"
    puts product

   respond_to do |format|
          @sos=SaleOnSale.find(product.sale_on_sale_id)
          if @sos.destroy
          product.update_attributes(:is_sos => false , :sale_on_sale_id => nil , :on_sale_amount => nil)
          puts "Inside:: #{@sos}"
          format.html { redirect_to :back, :notice => "#{product.name}'s promoted amount has been deleted successfully!" }
          format.xml
         else
          format.html { redirect_to :back, :alert => "#{product.name}'s promoted SOS couldn't be updated. Here is the error: #{product.errors}" }
         end    
    end
  end

  def new
     
  end
  
  def new_sos
      start_date=("#{params[:st_date][:year]}-#{params[:st_date][:month]}-#{params[:st_date][:day]}").to_date
      end_date=("#{params[:end_date][:year]}-#{params[:end_date][:month]}-#{params[:end_date][:day]}").to_date
      puts start_date
       promoted_amount = BigDecimal.new(params[:promo_amount])
      product = Variant.where(:sku => params[:sku]).first.try(:product)
      if product.nil?
        redirect_to sale_promotions_path , :notice => "Product Not Found!!!!!!"
      else
        sale_on_sale = SaleOnSale.new(:name => "Sale on Sale", :description => "Sale on Sale..", :amount => (product.price-promoted_amount), :starts_at => start_date, :expires_at => end_date)
        sale_on_sale.code = sale_on_sale.gen_code
        sale_on_sale.save
        product.update_attributes(:is_sos => true, :sale_on_sale_id => sale_on_sale.id, :on_sale_amount => promoted_amount)
        redirect_to sale_promotions_path , :notice => "New SaleOnSale data created" 
      end
    
  end
end
