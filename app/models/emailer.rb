class Emailer < ActionMailer::Base
  def send_activation_request(user)
  		recievers = ['Ghufran <emghufran@gmail.com>', 'Ghufran <mghfrn@gmail.com>']
  		subject     	"New User registration request"
      recipients  	recievers
      from        	'explosive.inventory@gmail.com'
      sent_on     	Time.now
      body				:user => user
      content_type	"text/html"
   end  

	def account_activation_confirmation(user)
		recievers = ['emghufran@gmail.com', 'mghfrn@gmail.com']
      subject     "Registration Confirmed"
      recipients  recievers
      from        'explosive.inventory@gmail.com'
      sent_on     Time.now
      body			:user => user
		content_type	"text/html"
	end

	def approve_job_request(job, user)
		recievers = ['emghufran@gmail.com', 'mghfrn@gmail.com']
		job_details = JobDetail.find(:all, :conditions => ["job_id = ? ", job.id],
  	 						:joins => " INNER JOIN products p ON job_details.part_id = p.id 
  	 										INNER JOIN bunkers b ON job_details.bunker_id = b.id 
  	 										INNER JOIN update_inventories ui ON job_details.part_id = ui.part_id AND job_details.bunker_id = ui.bunker_id ", 
  	 						:select => "job_details.*, p.part_number, p.description AS part_desc, b.name AS bunker_name, ui.quantity AS available_quantity" )
  	 						
		subject     "New Job Request"
      recipients  recievers
      from        'explosive.inventory@gmail.com'
      sent_on     Time.now
      body			:user => user, :job => job, :job_details => job_details
      content_type	"text/html"
	end
	
	def notify_job_confirmation(job, user, decision = 'approved')
		recievers = ['emghufran@gmail.com', 'mghfrn@gmail.com']
		job_details = JobDetail.find(:all, :conditions => ["job_id = ? ", job.id],
  	 						:joins => " INNER JOIN products p ON job_details.part_id = p.id 
  	 										INNER JOIN bunkers b ON job_details.bunker_id = b.id 
  	 										INNER JOIN update_inventories ui ON job_details.part_id = ui.part_id AND job_details.bunker_id = ui.bunker_id ", 
  	 						:select => "job_details.*, p.part_number, p.description AS part_desc, b.name AS bunker_name, ui.quantity AS available_quantity" )
  	 	sub = (decision == 'approved' ? 'Job Approved' : "Job Declined")
  	 						
		subject     sub
      recipients  recievers
      from        'explosive.inventory@gmail.com'
      sent_on     Time.now
      body			:user => user, :job => job, :job_details => job_details, :decision => decision
      content_type	"text/html"
	end
	
	def notify_insufficient_supplies(user, product_id, bunker_id, quantity)
		recievers = ['emghufran@gmail.com', 'mghfrn@gmail.com']
		product = Product.find(:first, :conditions => ["id = ? ", product_id])
		bunker = Bunker.find(:first, :conditions => ["id = ? ", bunker_id])
		inventory = UpdateInventory.find(:first, :conditions => ["part_id = ? and bunker_id = ? ", product_id, bunker_id])
		  	 						
		subject     "Insufficient supplies in Inventory"
      recipients  recievers
      from        'explosive.inventory@gmail.com'
      sent_on     Time.now
      body			:user => user, :product => product, :bunker => bunker, :quantity => quantity, :inventory => inventory
      content_type	"text/html"
	end
end
