class SalePromotionsController < ApplicationController
  before_filter :authenticate_user_role
  layout "sale_on_sale"
  
  def authenticate_user_role
    redirect_to root_path if (current_user.nil? ? true : !current_user.roles.map(&:name).include?("cs"))
  end

  def index
    @sale_on_sale = SaleOnSaleImport.new
    @products = Product.select("id,name,permalink, promoted_amount, promotion_id").promoted.reverse
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  def show
    @promotion = Product.find_by_permalink(params[:id])
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  def edit
    @promotion = Product.find_by_permalink(params[:id])
    respond_to do |format|
      format.html
      format.xml
    end
  end

  def update
    product = Product.find_by_permalink(params[:id])
    respond_to do |format|
      if product.update_attributes(params[:product])
        format.html { redirect_to :back, :notice => "#{product.name}'s promoted amount has been updated successfully!" }
        format.xml
      else
        format.html { redirect_to :back, :alert => "#{product.name}'s promoted amount couldn't be updated. Here is the error: #{product.errors}" }
      end
    end
  end
end
