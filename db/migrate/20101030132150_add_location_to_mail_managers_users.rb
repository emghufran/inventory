class AddLocationToMailManagersUsers < ActiveRecord::Migration
  def self.up
     add_column :mail_managers, :location, :string
     add_column :users, :location, :string
  end

  def self.down
    remove_column :mail_managers, :location
    remove_column :users, :location
  end
end
