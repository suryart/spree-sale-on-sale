class SalePromotionsController < ApplicationController
  before_filter :authenticate_user_role
  
  def authenticate_user_role
    rediect_to root_path if (current_user.nil? ? true : !current_user.roles.map(&:name).include?("cs"))
  end

  def index
    @promotions = Promotion.sale_on_sale
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  def show
    @promotion = Promotion.find(params[:id])
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  def edit
    @promotion = Promotion.find(params[:id])
    respond_to do |format|
      format.html
      format.xml
    end
  end
end
