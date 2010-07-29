class AddBunkeridColumnOrders < ActiveRecord::Migration
  def self.up
  add_column :orders, :bunker_id, :int
  end

  def self.down
  remove_column :orders, :bunker_id
  end
end
