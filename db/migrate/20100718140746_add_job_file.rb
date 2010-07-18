class AddJobFile < ActiveRecord::Migration
  def self.up
    add_column "jobs", "attachment_path", :string, :length => 255
  end

  def self.down
    remove_column "jobs", "attachment_path"
  end
end
