class CreateOrder < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :part_id
      t.integer :user_id
      t.integer :original_quantity
      t.integer :received_quantity
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
