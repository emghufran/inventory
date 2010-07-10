class JobsController < ApplicationController

  def new
    @existing_quantity = 0
    @products = Product.find(:all,:order => 'id ASC')
    @bunkers = Bunker.find(:all, :order => 'id ASC')
    product_count = UpdateInventory.find( :first, :conditions => ["part_id = ? and bunker_id = ?", @products[0].id, @bunkers[0].id] ) if @bunkers and @products
    @existing_quantity = product_count.quantity unless product_count.nil?

  end
end
