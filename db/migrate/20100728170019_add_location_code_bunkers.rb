class AddLocationCodeBunkers < ActiveRecord::Migration
  def self.up
    add_column :bunkers, :location_code, :string
  end

  def self.down
    remove_column :bunkers, :location_code
  end
end
