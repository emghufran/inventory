class CreateJob < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.integer :part_id
      t.integer :user_id
      t.integer :bunker_id
      t.integer :quantity
      t.integer :consumed
      t.integer :junk
      t.integer :sign_in
      t.string  :engineer
      t.string  :gun_shop_superviser
      t.string :truck
      t.string  :rig
      t.string  :well
      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
