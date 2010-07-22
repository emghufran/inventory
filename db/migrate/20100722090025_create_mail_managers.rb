class CreateMailManagers < ActiveRecord::Migration
  def self.up
    create_table :mail_managers do |t|
      t.column :email,      :string, :limit => 255
      t.column :role,       :string, :limit => 64
      
      t.timestamps
    end
  end

  def self.down
    drop_table :mail_managers
  end
end
