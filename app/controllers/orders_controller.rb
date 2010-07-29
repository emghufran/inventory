class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.xml
  before_filter :validate_authentication
  def index
    @orders = Order.find(:all, :joins => "INNER JOIN products p ON orders.part_id = p.id", :select => "orders.*, p.description, p.part_number")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show

    @order = Order.find(params[:id],:joins => "INNER JOIN products p ON orders.part_id = p.id", :select => "orders.*, p.description, p.part_number")
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  def new
    @order = Order.new
    @order[:status]="Order Made"
    @products = Product.find(:all,:order => 'id ASC')

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id],:joins => "INNER JOIN products p ON orders.part_id = p.id", :select => "orders.*, p.description, p.part_number")
  end

  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(params[:order])
    respond_to do |format|
      if @order.save
        flash[:notice] = 'Order was successfully created.'
        format.html { redirect_to(@order) }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])
    respond_to do |format|
      if @order.update_attributes("status"=>params[:order][:status],"received_quantity"=>params[:order][:received_quantity])
        if(!params[:order][:bunker_id].nil?)
          @order.update_attributes("bunker_id"=>params[:order][:bunker_id])
          part_id = Product.find(:first, :conditions => ["part_number = ? ", params[:order][:part_number]]).id
          @inventory = UpdateInventory.find(:first, :conditions => ["part_id = ? and bunker_id = ?", part_id, params[:order][:bunker_id]]) || UpdateInventory.new
          @inventory.part_id = part_id
          @inventory.bunker_id = params[:order][:bunker_id]
          if @inventory.quantity.nil?
            @inventory.quantity = params[:order][:received_quantity]  
          else
            @inventory.quantity = @inventory.quantity + params[:order][:received_quantity].to_i()
          end

          if @inventory.save
              flash[:notice] = 'Inventory updated successfully.'
          else
              flash[:notice] = 'Inventory cannot be updated at this time.'
          end
        end
        flash[:notice] = 'Order was successfully updated.'
        format.html { redirect_to(@order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end
  def receive
    @order = Order.find(params[:id],:joins => "INNER JOIN products p ON orders.part_id = p.id", :select => "orders.*, p.description, p.part_number")
    @order[:status]="Received"
    @bunkers = Bunker.find(:all,:order => 'id ASC')
  end
end
