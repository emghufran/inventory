class CreateMovement < ActiveRecord::Migration
  def self.up
    create_table :movements do |t|
      t.integer :part_id
      t.integer :from_id
      t.integer :to_id
      t.integer :quantity
      t.string  :location
      t.timestamps
    end
  end

  def self.down
    drop_table :movements
  end
end
