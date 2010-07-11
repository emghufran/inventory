class JobDetails < ActiveRecord::Migration
  def self.up
    create_table :job_details do |t|
      t.integer :job_id
      t.integer :part_id
      t.integer :bunker_id
      t.integer :quantity
      t.integer :consumed
      t.integer :junk
      t.integer :sign_in
      t.timestamps
    end

  end

  def self.down
    drop_table :job_details
  end
end
