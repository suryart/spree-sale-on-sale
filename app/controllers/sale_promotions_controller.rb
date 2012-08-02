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
end
