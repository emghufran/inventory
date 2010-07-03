class UserActivatedCheck < ActiveRecord::Migration
  def self.up
    add_column "users", "is_approved", :integer, :default => 0
  end

  def self.down
    remove_column 'users', 'is_approved'
  end
end
