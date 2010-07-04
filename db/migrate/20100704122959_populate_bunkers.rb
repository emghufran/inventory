class PopulateBunkers < ActiveRecord::Migration
  def self.up
	execute "
INSERT INTO bunkers (name, location) VALUES 
('Khaskeili - 1', 'Khaskeili'),
('Khaskeili - 2', 'Khaskeili'),
('Khaskeili - 3', 'Khaskeili'),
('Khaskeili - 4', 'Khaskeili'),
('Khaskeili - 5', 'Khaskeili'),
('Khaskeili - 6', 'Khaskeili'),
('Sukhar - Primary', 'Sukhar'),
('Sukhar - Secondary', 'Sukhar'),
('Khoar - Primary', 'Khoar'),
('Khoar - Secondary', 'Khoar');"
  end

  def self.down
	execute "TRUNCATE TABLE bunkers;"
  end
end
