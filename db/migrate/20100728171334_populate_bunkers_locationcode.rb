class PopulateBunkersLocationcode < ActiveRecord::Migration
 
  def self.up
	execute "TRUNCATE TABLE bunkers;"
execute "INSERT INTO bunkers (name, location,location_code) VALUES
('Khaskeili - 1', 'Khaskeili','PKKA'),
('Khaskeili - 2', 'Khaskeili','PKKA'),
('Khaskeili - 3', 'Khaskeili','PKKA'),
('Khaskeili - 4', 'Khaskeili','PKKA'),
('Khaskeili - 5', 'Khaskeili','PKKA'),
('Khaskeili - 6', 'Khaskeili','PKKA'),
('Sukhar - Primary', 'Sukhar','PKSA'),
('Sukhar - Secondary', 'Sukhar','PKSA'),
('Khoar - Primary', 'Khoar','PKIS'),
('Khoar - Secondary', 'Khoar','PKIS');"
  end

  def self.down
	execute "TRUNCATE TABLE bunkers;"
  end
end
