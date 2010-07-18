class ProductsController < ApplicationController
  layout 'application'
  # GET /products
  # GET /products.xml
  def index
    @products = Product.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        flash[:notice] = 'Product was successfully created.'
        format.html { redirect_to(@product) }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        flash[:notice] = 'Product was successfully updated.'
        format.html { redirect_to(@product) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end

  def update_inventory
    @existing_quantity = 0
    @products = Product.find(:all,:order => 'id ASC')
    @bunkers = Bunker.find(:all, :order => 'id ASC')
    product_count = UpdateInventory.find( :first, :conditions => ["part_id = ? and bunker_id = ?", @products[0].id, @bunkers[0].id] ) if @bunkers and @products
    @existing_quantity = product_count.quantity unless product_count.nil?
  end

  def get_existing_quantity
    product_count = get_product_quantity(params[:part_id], params[:bunker_id])
    render :text=> product_count
    #render :text=> (product_count.nil? ? 0 : product_count.quantity)
  end

  def get_existing_quantity1
    product_count = UpdateInventory.find( :first, :conditions => ["part_id = ? and bunker_id = ?", params[:part_id], params[:bunker_id]] )
    render :text=> (product_count.nil? ? 0 : product_count.quantity)
  end
  
  def update_inventory_submit
    @inventory = UpdateInventory.find(:first, :conditions => ["part_id = ? and bunker_id = ?", params[:update_inventory][:part_number], params[:update_inventory][:bunker]]) || UpdateInventory.new
    @inventory.part_id = params[:update_inventory][:part_number]
    @inventory.bunker_id = params[:update_inventory][:bunker]
    @inventory.quantity = params[:update_inventory][:new_quantity]
    if @inventory.save
        flash[:notice] = 'Inventory updated successfully.'
    else
        flash[:notice] = 'Inventory cannot be updated at this time.'
    end
  end
end
