class SaleOnSaleImportsController < ApplicationController

  before_filter :authenticate_user_role
  layout "sale_on_sale"
  
  def authenticate_user_role
    redirect_to root_path if (current_user.nil? ? true : !current_user.roles.map(&:name).include?("cs"))
  end

  # GET /sale_on_sale_imports
  # GET /sale_on_sale_imports.xml
  def index
    @sale_on_sale_import = SaleOnSaleImport.new
    @sale_on_sale_imports = SaleOnSaleImport.all.reverse.paginate(:page => params[:page], :per_page => 50)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sale_on_sale_imports }
    end
  end

  # GET /sale_on_sale_imports/1
  # GET /sale_on_sale_imports/1.xml
  # def show
  #   @sale_on_sale_import = SaleOnSaleImport.find(params[:id])

  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.xml  { render :xml => @sale_on_sale_import }
  #   end
  # end

  # GET /sale_on_sale_imports/new
  # GET /sale_on_sale_imports/new.xml
  def new
    @sale_on_sale_import = SaleOnSaleImport.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sale_on_sale_import }
    end
  end

  # GET /sale_on_sale_imports/1/edit
  def edit
    @sale_on_sale_import = SaleOnSaleImport.find(params[:id])
  end

  # POST /sale_on_sale_imports
  # POST /sale_on_sale_imports.xml
  def create
    params[:sale_on_sale_import][:user_id] = current_user.id
    @sale_on_sale_import = SaleOnSaleImport.new(params[:sale_on_sale_import])

    respond_to do |format|
      if @sale_on_sale_import.save
        format.html { redirect_to(:back, :notice => 'Sale on sale import was successfully created.') }
        format.xml  { render :xml => @sale_on_sale_import, :status => :created, :location => @sale_on_sale_import }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sale_on_sale_import.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sale_on_sale_imports/1
  # PUT /sale_on_sale_imports/1.xml
  def update
    params[:sale_on_sale_import][:user_id] = current_user.id
    @sale_on_sale_import = SaleOnSaleImport.find(params[:id])

    respond_to do |format|
      if @sale_on_sale_import.update_attributes(params[:sale_on_sale_import])
        format.html { redirect_to(:back, :notice => 'Sale on sale import was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sale_on_sale_import.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sale_on_sale_imports/1
  # DELETE /sale_on_sale_imports/1.xml
  def destroy
    @sale_on_sale_import = SaleOnSaleImport.find(params[:id])
    @sale_on_sale_import.destroy

    respond_to do |format|
      format.html { redirect_to(sale_on_sale_imports_url) }
      format.xml  { head :ok }
    end
  end
end
