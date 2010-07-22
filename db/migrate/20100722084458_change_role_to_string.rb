class ChangeRoleToString < ActiveRecord::Migration
  def self.up
    remove_column :users, :role_id
    add_column :users, :role, :string, :default => "Engineer"
  end

  def self.down
    remove_column :users, :role
    add_column :users, :role_id, :integer
  end
end
