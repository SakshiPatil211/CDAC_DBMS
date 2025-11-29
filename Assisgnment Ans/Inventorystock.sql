CREATE TABLE IF NOT EXISTS Inventory (
  inventory_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  product_id INT,
  quantity INT DEFAULT 0,
  reorder_level INT DEFAULT 10,
  last_updated DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE IF NOT EXISTS ReorderRequests (
  reorder_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  inventory_id INT,
  request_date DATE DEFAULT (CURRENT_DATE),
  quantity_requested INT,
  status VARCHAR(20) DEFAULT 'pending'
);

DELIMITER $$
CREATE PROCEDURE scan_and_reorder()
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE v_inv INT;
  DECLARE v_qty INT;
  DECLARE v_reorder INT;
  DECLARE cur1 CURSOR FOR
    SELECT inventory_id, quantity, reorder_level FROM Inventory;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_inv, v_qty, v_reorder;
    IF done = 1 THEN
      LEAVE read_loop;
    END IF;

    IF v_qty < v_reorder THEN
      INSERT INTO ReorderRequests(inventory_id, quantity_requested) VALUES(v_inv, v_reorder - v_qty);
    END IF;
  END LOOP;
  CLOSE cur1;
END$$
DELIMITER ;

