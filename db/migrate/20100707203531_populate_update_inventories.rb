class PopulateUpdateInventories < ActiveRecord::Migration
  def self.up
    execute("
INSERT INTO update_inventories (part_id, bunker_id, quantity, created_at) VALUES
(1, 1, 100, now()),
(1, 2, 1000, now()),
(1, 3, 200, now()),
(2, 1, 100, now()),
(2, 2, 500, now()),
(2, 3, 1000, now()),
(3, 1, 100, now()),
(4, 1, 100, now()),
(5, 1, 100, now()),
(6, 1, 100, now())
")
  end

  def self.down
  end
end
