class AlterMovements < ActiveRecord::Migration
  def self.up
    add_column :movements, :movement_type, :string, :length => 64
  end

  def self.down
    remove_column :movements, :movement_type
  end
end
