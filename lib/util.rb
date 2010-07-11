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