def get_product_quantity(part_id = nil, bunker_id = nil)
  part_id = params[:part_id] if !part_id and params and !params.nil?
  bunker_id = params[:bunker_id] if !bunker_id and params and !params.nil?
    
  product_count = UpdateInventory.find( :first, :conditions => ["part_id = ? and bunker_id = ?", part_id, bunker_id] )
  return (product_count.nil? ? 0 : product_count.quantity)
  #render :text=> (product_count.nil? ? 0 : product_count.quantity)
end

def resize_string(target_string, target_length = 17)
	return (target_string.length > target_length ? target_string[0..target_length - 1] + '...' : target_string) 
end

def write_job_summary_csv(results)
	file_path = "#{RAILS_ROOT}/reports/" + Time.now.strftime('%Y%m%d') + "job_summary.csv"
	file = File.open(file_path, "w")
	file.puts "Issue Date,Truck,Part No.,Description,Total Quantity,Consumed,Junk,Signed-In,Return Date,Well name,Engineer,Client"
	write_str = ''
	sep_str = ''
	results.each do |r|
		write_str = r.collect {|elem| elem = '' if !elem; elem.gsub(',', '')}.join(',')
		file.puts write_str
	end	
	file.close
	return file_path
end

def write_fmtinout_csv(results)
	file_path = "#{RAILS_ROOT}/reports/" + Time.now.strftime('%Y%m%d') + "_fmt_in_out.csv"
	file = File.open(file_path, "w")
	file.puts "PartNumber, Description, Um,FMTIN,FMTOUT,Locaion"
	write_str = ''
	results.each do |r|
		write_str = r.collect {|elem| elem = '' if !elem; elem.gsub(',', '')}.join(',')
		file.puts write_str
	end
	file.close
	return file_path
end

def write_explosive_bunker_csv(results, location)
	file_path = "#{RAILS_ROOT}/reports/" + Time.now.strftime('%Y%m%d') + "_#{location}_explosives_summary_bunker_based.csv"
	file = File.open(file_path, "w")
	file.puts "Bunker,Part Number,Description,Closing quantity,Field in,Field out,Field junk,Fmt in,Fmt out,Used,Received,Opening Quantity"
	write_str = ''
	results.each do |r|
		write_str = r.collect {|elem| elem = '' if !elem; elem.gsub(',', '')}.join(',')
		file.puts write_str
	end
	file.close
	return file_path
end

def write_explosive_csv(results, location)
	file_path = "#{RAILS_ROOT}/reports/" + Time.now.strftime('%Y%m%d') + "_#{location}_explosives_summary_location_based.csv"
	file = File.open(file_path, "w")
	file.puts " Part Number,Description,Received,Fmt in, Field in,Field Out,Fmt out ,Field Junk,Used,Closing quantity,Opening quantity"
	write_str = ''
	results.each do |r|
		write_str = r.collect {|elem| elem = '' if !elem; elem.gsub(',', '')}.join(',')
		file.puts write_str
	end
	file.close
	return file_path
end

def validate_authentication
	if !session[:user_id] || session[:user_id].blank? || session[:user_id].to_i <= 0
		flash[:notice] = "Authorization required! Please login to continue.."
		redirect_to :controller => "sessions", :action => "new"
		return
	end
	if !session[:is_approved] || session[:is_approved] == 0
		flash[:notice] = "Your account is not yet approved. You need an approved account to use this system."
		redirect_to :controller => "main", :action => "index"
		return
	end 
end

def validate_admin_authentication
	if !session[:user_id] || session[:user_id].blank? || session[:user_id].to_i <= 0
		flash[:notice] = "Authorization required! Please login to continue.."
		redirect_to :controller => "sessions", :action => "new"
		return
	elsif !session[:is_approved] || session[:is_approved] == 0
		flash[:notice] = "Your account is not yet approved. You need an approved account to use this system."
		redirect_to :controller => "main", :action => "index"
		return
	elsif session[:role] != 'Manager'
		flash[:notice] = "You need administrative priviledges to use this section. Please sign in with an Administrative access."
		redirect_to :controller => "main", :action => "index"
		return
	end
	return true
end

def create_hazmat_form(job, job_details)
#	file_path = "#{RAILS_ROOT}/reports/" + Time.now.strftime('%Y%m%d') + "_hazmat_form.csv"
#	file = File.open(file_path, "w")
#	file.puts ""
#  file.puts "#{job.engineer},#{job.truck},#{job.rig} ,#{job.well} ,#{job.explosive_van} ,#{job.client_name}"
#  file.puts ""
#  file.puts "Part No,Description,Out,Use,In,Un #,Class,NEC,Quantity,Weight(gr),Junk"
#	write_str = ''
#  job_details.each do |r|
#		write_str = r[:part_number] + ","+r[:description].gsub(/[,]/, ' ')  +","+r[:quantity].to_s+", , ,"+r[:un_num]+","+r[:class_name]+", ,"+r[:quantity].to_s+","+(r[:quantity]*r[:net_weight].to_i).to_s+","
#		file.puts write_str
#	end
#	file.close
#	return file_path

  require "spreadsheet"
file_path = "#{RAILS_ROOT}/reports/" + Time.now.strftime('%Y%m%d') + "_hazmat_form.csv"
book = Spreadsheet::Workbook.new
sheet1 = book.create_worksheet #default sheet name Worksheet1
sheet1.name = 'Hazmat Form'

sheet1.row(0).push 'Hazmat Form'
sheet1.row(0).height = 20
sheet1.column(0).width = 20
sheet1.column(1).width = 40

sheet1.row(1).push 'Engineer:', job.engineer
sheet1.row(2).push 'Truck:',job.truck
sheet1.row(3).push 'Rig:', job.rig
sheet1.row(4).push 'Well:', job.well
sheet1.row(5).push 'Explosive Van:',job.explosive_van
sheet1.row(6).push 'Client Name:',job.client_name
sheet1.row(8).push 'Part No','Description','Out','Use','In','Un #','Class','NEC','Quantity','Weight(gr)','Junk'

current_row = 9
job_details.each do |r|
 sheet1.row(current_row).push r[:part_number] ,r[:description].gsub(/[,]/, ' ')  ,r[:quantity].to_s,'','',r[:un_num],r[:class_name],"",r[:quantity].to_s,(r[:quantity]*r[:net_weight].to_i).to_s
 current_row = current_row +1
end
format = Spreadsheet::Format.new :color => :black,:weight => :bold,:size =>18
sheet1.row(0).default_format = format

  black_bold = Spreadsheet::Format.new :weight => :bold

bold = Spreadsheet::Format.new :weight => :bold,:color => :gray
6.times do |x| sheet1.row(x + 1).set_format(0, bold) end
6.times do |x| sheet1.row(x + 1).set_format(1, black_bold) end

sheet1.row(8).default_format = bold


book.write file_path
return file_path
end

