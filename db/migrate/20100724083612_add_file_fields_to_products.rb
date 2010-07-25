class AddFileFieldsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :ce_certificate, :string, :length => 255
    add_column :products, :transport_approval_document, :string, :length => 255
    add_column :products, :product_identification_sheet, :string, :length => 255
    add_column :products, :msds, :string, :length => 255
    add_column :products, :declaration_of_conformity, :string, :length => 255
  end

  def self.down
    remove_column :products, :ce_certificate
    remove_column :products, :transport_approval_document
    remove_column :products, :product_identification_sheet
    remove_column :products, :msds
    remove_column :products, :declaration_of_conformity
  end
end
