class MovementController < ApplicationController
  def index
  	 @existing_quantity = 0
    @products = Product.find(:all,:order => 'id ASC')
    @bunkers = Bunker.find(:all, :order => 'id ASC')
    product_count = UpdateInventory.find( :first, :conditions => ["part_id = ? and bunker_id = ?", @products[0].id, @bunkers[0].id] ) if @bunkers and @products
    @existing_quantity = product_count.quantity unless product_count.nil?
  end

	def create
		product_id = params[:products]
		from_field = params[:bunkers]
		to_field = params[:bunkers_to]
		movement_type = params[:movement_type]
		quantity = params[:quantity].to_i
		location = params[:overseas_location]
		debugger
		if(movement_type.downcase == "fmt")
		  ui = UpdateInventory.find(:first, :conditions => ["part_id = ? and bunker_id = ? ", product_id, from_field])
		  if !ui
		  	 flash[:notice] = "Invalid Input"
		  	 redirect_to :controller => 'movement', :action => 'index'
		  	 return
		  end
		  if from_field.strip.to_i == to_field.strip.to_i
		    flash[:notice] = "Please choose different bunkers to move product"
		  	 redirect_to :controller => 'movement', :action => 'index'
		  	 return
		  end
		  if ui.quantity < quantity
		  	 flash[:notice] = "Movement quantity is more than what is actually available"
		  	 redirect_to :controller => 'movement', :action => 'index'
		  	 return
		  end
		  ui.quantity = ui.quantity - quantity
		  ui.save
		  
		  ui2 = UpdateInventory.find(:first, :conditions => ["part_id = ? and bunker_id = ? ", product_id, to_field])
		  if !ui2
		    UpdateInventory.create(:part_id => product_id, :bunker_id => to_field, :quantity => quantity)
		  else
		  	 ui2.quantity = ui2.quantity + quantity
		  	 ui2.save
		  end	  
		  
		  Movement.create(:part_id => product_id, :from_id => from_field, :to_id => to_field, :quantity => quantity, :movement_type => "FMTOUT")
		  Movement.create(:part_id => product_id, :from_id => to_field, :to_id => from_field, :quantity => quantity, :movement_type => "FMTIN")
		elsif(movement_type.downcase == "tcp")
		  ui = UpdateInventory.find(:first, :conditions => ["part_id = ? and bunker_id = ? ", product_id, from_field])
		  if !ui
		  	 flash[:notice] = "Invalid Input"
		  	 redirect_to :controller => 'movement', :action => 'index'
		  	 return
		  end
		  if ui.quantity < quantity
		  	 flash[:notice] = "Movement quantity is more than what is actually available"
		  	 redirect_to :controller => 'movement', :action => 'index'
		  	 return
		  end
		  ui.quantity = ui.quantity - quantity
		  ui.save
		  
		  Movement.create(:part_id => product_id, :from_id => from_field, :to_id => from_field, :quantity => quantity, :movement_type => "TCP")		
		elsif(movement_type.downcase == "wireline")
		  ui = UpdateInventory.find(:first, :conditions => ["part_id = ? and bunker_id = ? ", product_id, to_field])
		  if !ui
		    UpdateInventory.create(:part_id => product_id, :bunker_id => to_field, :quantity => quantity)
		  else
		  	 ui.quantity = ui.quantity + quantity
		  	 ui.save
		  end	  
		  
		  Movement.create(:part_id => product_id, :from_id => to_field, :to_id => to_field, :quantity => quantity, :movement_type => "WIRELINE")
		elsif(movement_type.downcase == "overseas")
		  ui = UpdateInventory.find(:first, :conditions => ["part_id = ? and bunker_id = ? ", product_id, from_field])
		  if !ui
		  	 flash[:notice] = "Invalid Input"
		  	 redirect_to :controller => 'movement', :action => 'index'
		  	 return
		  end
		  if ui.quantity < quantity
		  	 flash[:notice] = "Movement quantity is more than what is actually available"
		  	 redirect_to :controller => 'movement', :action => 'index'
		  	 return
		  end
		  ui.quantity = ui.quantity - quantity
		  ui.save
		  
		  Movement.create(:part_id => product_id, :from_id => from_field, :to_id => from_field, :quantity => quantity, :movement_type => "OVERSEAS", :location => location)
		end
		
		flash[:notice] = "Movement completed successfully"
		redirect_to :controller => 'movement', :action => 'index'
	end
end
