class JobsController < ApplicationController

  def new
    @existing_quantity = 0
    @products = Product.find(:all,:order => 'id ASC')
    @bunkers = Bunker.find(:all, :order => 'id ASC')
    product_count = UpdateInventory.find( :first, :conditions => ["part_id = ? and bunker_id = ?", @products[0].id, @bunkers[0].id] ) if @bunkers and @products
    @existing_quantity = product_count.quantity unless product_count.nil?

  end
 
  def index
    @jobs = Job.find(:all, :conditions => ["status = 'Open'"], :order => "id DESC")
  end
   
  def create
    products = params[:products].split("||");
    products_list = []
    products.each do |p|
    	debugger
    	 prd = p.split('|');
    	 if prd.length != 3
    	 	render :text => "Invalid Input" 
    	 	return
    	 end
    	 prd[0] = prd[0].sub('product', '').to_i
		 prd[1] = prd[1].sub('bunker', '').to_i
		 prd[2] = prd[2].sub('quantity', '').to_i
    	 available_quantity = get_product_quantity(prd[0], prd[1])
    	 if available_quantity < prd[2]
    	 	render :text => "Available Quantity is less than the requested quantity."
    	 	return
    	 end
		 products_list << prd    	 
    end
    #Validation Complete. Insert and redirect to success.
    j = Job.new
	 j.user_id = session[:user_id]
	 j.status = "Open"
	 j.save
	 job_id = j.id
	 if(!job_id or job_id.nil?)
	 	render :text => "Unable to save Job" 
    	return
    else
    	products_list.each do |p|
			ui = UpdateInventory.find(:first, :conditions => ["part_id = ? AND bunker_id = ?", p[0], p[1]])
			ui.quantity = ui.quantity - p[2]
			ui.save
			
    		jd = JobDetail.new
    		jd.job_id = job_id
    		jd.part_id = p[0]
    		jd.bunker_id = p[1]
    		jd.quantity = p[2]
    		jd.save
    		
    	end
	 end
	 #redirect_to "/jobs/view/#{job_id}"
	 render :text => job_id
	       
  end

  def show
  	 @job = Job.find(params[:id])
  	 if(!@job || @job.nil?) 
  	 	render :text => "No record for the requested Job."
  	 	return
  	 end
  	 	
  	 @job_details = JobDetail.find(:all, :conditions => ["job_id = ? ", @job.id],
  	 						:joins => " INNER JOIN products p ON job_details.part_id = p.id 
  	 										INNER JOIN bunkers b ON job_details.bunker_id = b.id 
  	 										INNER JOIN update_inventories ui ON job_details.part_id = ui.part_id AND job_details.bunker_id = ui.bunker_id ", 
  	 						:select => "job_details.*, p.part_number, p.description AS part_desc, b.name AS bunker_name, ui.quantity AS available_quantity" )
  	 
  	 
  	 @products = Product.find(:all,:order => 'id ASC')
    @bunkers = Bunker.find(:all, :order => 'id ASC')
    product_count = UpdateInventory.find( :first, :conditions => ["part_id = ? and bunker_id = ?", @products[0].id, @bunkers[0].id] ) if @bunkers and @products
    @existing_quantity = product_count.quantity unless product_count.nil?
  end
  
  def edit
  	 edit_id = params[:id]
    
  end

  def update_product
  	 product_id = params[:product_id]
  	 bunker_id = params[:bunker_id]
  	 job_id = params[:job_id]
  	 quantity = params[:quantity].to_i
  	 if(!product_id or !bunker_id or !quantity)
  	 	render :text => "Invalid Parameters."
  	 	return
  	 end
	 
	 available_quantity = get_product_quantity(product_id, bunker_id)  	 
  	 if(available_quantity < quantity)
  	 	render :text => "Available Quantity is less than the requested quantity."
  	 	return
  	 end
	
	 job_detail = JobDetail.find(:first, 
	 								:conditions => ["job_id = ? AND part_id = ? AND bunker_id = ?", job_id, product_id, bunker_id])
	 
	 if(!job_detail)
	 	render :text => "Error Finding requested part with this job."
  	 	return
	 end
	 #update the inventory.. 20  					10			
	 #update_value = (job_detail.quantity < quantity ? quantity - job_detail.quantity : )
	 update_value = quantity - job_detail.quantity
		 
	 ui = UpdateInventory.find(:first, :conditions => ["part_id = ? AND bunker_id = ?", product_id, bunker_id])
	 debugger
	 if(!ui or ui.nil?)
	 	render :text => "Error Finding requested part with this job."
  	 	return
	 end
	  
	 ui.quantity = ui.quantity - update_value
	 ui.save
	
	 job_detail.quantity = quantity
	 job_detail.save  	 
	 
	 render :text => ui.quantity
  end
  
  def remove_product
  	 product_id = params[:product_id]
  	 bunker_id = params[:bunker_id]
  	 job_id = params[:job_id]

  	 if(!product_id or !bunker_id)
  	 	render :text => "Invalid Parameters."
  	 	return
  	 end
	 
	 job_detail = JobDetail.find(:first, 
	 								:conditions => ["job_id = ? AND part_id = ? AND bunker_id = ?", job_id, product_id, bunker_id])
	 
	 if(!job_detail)
	 	render :text => "Error Finding requested part with this job."
  	 	return
	 end
	 #update the inventory.. 20  					10			
	 #update_value = (job_detail.quantity < quantity ? quantity - job_detail.quantity : )
		 
	 ui = UpdateInventory.find(:first, :conditions => ["part_id = ? AND bunker_id = ?", product_id, bunker_id])
	 if(!ui or ui.nil?)
	 	render :text => "Error Finding requested part with this job."
  	 	return
	 end
	  
	 ui.quantity = ui.quantity + job_detail.quantity
	 ui.save
	
	 job_detail.delete  	 
	 
	 render :text => "SUCCESS"
  end
  
  def add_products
    job_id = params[:job_id]
    job = Job.find(job_id)
    
    job_details = JobDetail.find(:all, :conditions => ['job_id = ? ', job_id])
    if(!job_details or job_details.nil?)
    	render :text => "Unable to find job." 
    	return
    end
    
	 products = params[:products].split("||");
    products_list = []
    products.each do |p|
    	debugger
    	 prd = p.split('|');
    	 if prd.length != 3
    	 	render :text => "Invalid Input" 
    	 	return
    	 end
    	 prd[0] = prd[0].sub('product', '').to_i
		 prd[1] = prd[1].sub('bunker', '').to_i
		 prd[2] = prd[2].sub('quantity', '').to_i
		
		 #going to check if the same product/bunker combo exists..
		 job_details.each do |jd|
		 	if(jd.part_id == prd[0] and jd.bunker_id == prd[1])
		 		error_prd = Product.find(prd[0])
	    	 	render :text => "Part Number #{error_prd.part_number} already exists. Use update to change quantity." 
   	 	 	return
		 	end
		 end  
    	 available_quantity = get_product_quantity(prd[0], prd[1])
    	 if available_quantity < prd[2]
    	 	render :text => "Available Quantity is less than the requested quantity."
    	 	return
    	 end
		 products_list << prd    	 
    end
    #Validation Complete. Insert and redirect to success.
    products_list.each do |p|
		ui = UpdateInventory.find(:first, :conditions => ["part_id = ? AND bunker_id = ?", p[0], p[1]])
		ui.quantity = ui.quantity - p[2]
		ui.save
		
    	jd = JobDetail.new
    	jd.job_id = job_id
    	jd.part_id = p[0]
    	
    	jd.bunker_id = p[1]
    	jd.quantity = p[2]
    	jd.save
    end
    	
	 render :text => "SUCCESS"  
  end
  
  def close
  	 @job = Job.find(params[:id])
  	 if(!@job || @job.nil?) 
  	 	render :text => "No record for the requested Job."
  	 	return
  	 end
  	 	
  	 @job_details = JobDetail.find(:all, :conditions => ["job_id = ? ", @job.id],
  	 						:joins => " INNER JOIN products p ON job_details.part_id = p.id 
  	 										INNER JOIN bunkers b ON job_details.bunker_id = b.id 
  	 										INNER JOIN update_inventories ui ON job_details.part_id = ui.part_id AND job_details.bunker_id = ui.bunker_id ", 
  	 						:select => "job_details.*, p.part_number, p.description AS part_desc, b.name AS bunker_name, ui.quantity AS available_quantity" )
  	   
  end
end