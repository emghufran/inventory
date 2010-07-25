class AddExplosiveVanToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :explosive_van, :string, :limit => 64
  end

  def self.down
    remove_column :jobs, :explosive_van
  end
end
