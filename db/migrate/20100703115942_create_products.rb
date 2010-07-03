class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :part_number
      t.string :description
      t.decimal :lawson_price
      t.string :box_size
      t.integer :un_num
      t.string :class_name
      t.integer :package_quantity
      t.string :package_type
      t.decimal :gross_weight
      t.decimal :net_weight
      t.decimal :gm_box
      t.decimal :gm_unit
      t.string :um
      t.integer :spf
      t.datetime :updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
