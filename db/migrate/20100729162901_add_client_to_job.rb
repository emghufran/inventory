class AddClientToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, "client_name", :string, :limit => 128
  end

  def self.down
    remove_column :jobs, "client_name"
  end
end
