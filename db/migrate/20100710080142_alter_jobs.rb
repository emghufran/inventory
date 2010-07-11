class AlterJobs < ActiveRecord::Migration
  def self.up
    remove_column :jobs, :part_id
    remove_column :jobs, :bunker_id
    remove_column :jobs, :quantity
    remove_column :jobs, :consumed
    remove_column :jobs, :junk
    remove_column :jobs, :sign_in
    add_column :jobs, :status, :string, :limit => 40
  end

  def self.down
    add_column :jobs, :part_id, :integer
    add_column :jobs, :bunker_id, :integer
    add_column :jobs, :quantity, :integer
    add_column :jobs, :consumed, :integer
    add_column :jobs, :junk, :integer
    add_column :jobs, :sign_in, :integer
    remove_column :jobs, :status
  end
end
