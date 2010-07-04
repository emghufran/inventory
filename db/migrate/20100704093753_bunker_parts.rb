class BunkerParts < ActiveRecord::Migration
  def self.up
    create_table :bunker_parts do |t|
      t.integer :part_id
      t.integer :bunker_id
      t.integer :quantity
      t.timestamps
    end
  end

  def self.down
    drop_table :bunker_parts
  end
end
