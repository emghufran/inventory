class CreateUpdateInventories < ActiveRecord::Migration
  def self.up
    create_table :update_inventories do |t|
      t.integer :part_id
      t.integer :bunker_id
      t.integer :quantity
      t.timestamps
      end
  end

  def self.down
    drop_table :update_inventories
  end
end
