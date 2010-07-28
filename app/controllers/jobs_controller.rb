class JobsController < ApplicationController

  def new
    @existing_quantity = 0
    @products = Product.find(:all,:order => 'id ASC')
    @bunkers = Bunker.find(:all, :order => 'id ASC')
    product_count = UpdateInventory.find( :first, :conditions => ["part_id = ? and bunker_id = ?", @products[0].id, @bunkers[0].id] ) if @bunkers and @products
    @existing_quantity = product_count.quantity unless product_count.nil?
  end
 
  def index
    @jobs = Job.find(:all, :conditions => ["status = 'Approved'"], :order => "id DESC")
  end
   
  def create
    products = params[:products].split("||");
    products_list = []
    engineer = params[:engineer]
	 supervisor = params[:supervisor]
    well = params[:well]
    rig = params[:rig]
    truck = params[:truck]
    explosive_van = params[:explosive_van]

    if engineer.strip.length == 0 || supervisor.strip.length == 0 || well.strip.length == 0 || 
    	rig.strip.length == 0 || truck.strip.length == 0 || explosive_van.strip.length == 0 
    	render :text => "Please provide valid inputs for Engineer, Supervisor, Truck, Well, Rig and Explosive Van" 
      return
    end
    products.each do |p|
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
	 j.engineer = engineer
	 j.gun_shop_superviser = supervisor
	 j.well = well	 
	 j.rig = rig
	 j.truck = truck
	 j.explosive_van = explosive_van
	 j.status = "Pending Approval"
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
    	debugger
    	user = User.first
    	#Emailer.deliver_approve_job_request(j, user)
	 end

	 render :text => "#{job_id}||#{SITE_URL}/jobs/#{job_id}"
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
  
  def close_job
    job_id = params[:job_id]
  	@job = Job.find(job_id)
   debugger
  	products = params[:products]
    products = products.split("||")
    part_hash = {}
    products.each do |p|
      unique_job_params, quantities = p.split('|')
      
      if unique_job_params.blank? or quantities.blank?
        render :text => "Invalid Request Parameters"
        return
      end
      part_params = unique_job_params.match(/p(\d+)b(\d+)j(\d+)/)
      if part_params.length != 4
        render :text => "Invalid Part Parameters"
        return
      end

      stats = quantities.split(':').collect {|q| x = q[1..-1].to_i }
      if stats.length != 3 or stats[0] < 0 or stats[1] < 0 or stats[2] < 0
        render :text => "Invalid Quantities provided. They can't be negative or absent."
        return
      end
      j = JobDetail.find(:first, :conditions => ['job_id = ? and part_id = ? and bunker_id = ? ', job_id, part_params[1], part_params[2] ])
      if(stats[0] + stats[1] + stats[2] < j.quantity)
        render :text => "Closing quantities don't match checked out quantities"
        return
      end
      
      part_hash[unique_job_params] = stats
    end
    
    part_hash.each do |key, val| 
      part_params = key.match(/p(\d+)b(\d+)j(\d+)/)
      j = JobDetail.find(:first, :conditions => ['job_id = ? and part_id = ? and bunker_id = ? ', job_id, part_params[1], part_params[2] ])
      j.consumed = val[0]
      j.junk = val[1]
      j.sign_in = val[2]
      j.save

    end
    @job.status = "Closed"
    @job.save
    render :text => "SUCCESS|#{SITE_URL}/jobs"
  end
  
  def upload_file
    job_id = params[:job_id]
    redirect_url = params[:return_url]
    post = DataFile.save(params[:upload], "job#{job_id}")
    puts "<<<<<" + job_id + ">>>>>>"
    job = Job.find(job_id.to_i)
    job.attachment_path = post
    job.save
    
    redirect_to :controller => 'jobs', :action => 'show', :id => job_id
    #render :text => "done!"
  end
  
  def approve_job
	 job_id = params[:id]
  	 @job = Job.find(job_id.to_i)
  	 if !@job #didnt find user.
  	 	flash[:notice]  = "We couldn't find the requested job."
  	 	redirect_to :controller => 'main', :action => 'index'
  	 elsif @job.status == "Approved"
  	 	flash[:notice]  = "This job has already been Approved!"
  	 	redirect_to :controller => 'jobs', :action => 'show', :id => job_id
  	 end
  	 
  	 approval = params[:approval]
	 if(approval and approval.length > 0) 
	 	user = User.find(@job.user_id.to_i) || User.find(:first)
	 	decision = (approval.to_i == 1 ? "Approved" : "Declined")
	 	@job.status = decision
	 	@job.save
	 	Emailer.deliver_notify_job_confirmation(@job, user, decision.to_lower)
	 	flash[:notice] = "The job has been #{decision} and the concerning Engineers have been notified."
	 	redirect_to :controller => 'jobs', :action => 'show', :id => @job.id
	 end
  end
  
  def notify_low_inventory
	 product_id = params[:product_id]
	 bunker_id = params[:bunker_id]
	 quantity = params[:quantity]
	 debugger
	 if(session[:user_id])
	 	user = User.find(session[:user_id])
	 else
	 	user = User.find(:first)
	 end
	 Emailer.deliver_notify_insufficient_supplies(user, product_id, bunker_id, quantity)
	 
	 render :text => "SUCCESS"
  end
end
