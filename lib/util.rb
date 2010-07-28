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
	file.puts "Issue Date,Truck,Part No.,Description,Total Quantity,Consumed,Junk,Signed-In,Return Date,Well name,Engineer"
	write_str = ''
	sep_str = ''
	results.each do |r|
		write_str = r.collect {|elem| elem = '' if !elem; elem.gsub(',', '')}.join(',')
		file.puts write_str
	end	
	file.close
	return file_path
end