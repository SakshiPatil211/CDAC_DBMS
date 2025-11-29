DELIMITER $$
CREATE PROCEDURE place_order_shop(IN p_order_id INT, IN p_product_id INT, IN p_qty INT)
BEGIN
  DECLARE v_stock INT;
  DECLARE v_exists INT;

  SELECT stock INTO v_stock FROM shop_products WHERE product_id = p_product_id FOR UPDATE;
  IF v_stock IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product not found';
  END IF;

  IF v_stock < p_qty THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough stock';
  END IF;

  -- reduce stock
  UPDATE shop_products SET stock = stock - p_qty WHERE product_id = p_product_id;

  -- create or update order record
  INSERT INTO shop_orders(order_id, product_id, qty, status) VALUES(p_order_id, p_product_id, p_qty, 'PLACED')
  ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), qty = VALUES(qty), status = 'PLACED';

  -- log
  INSERT INTO order_log(order_id, action) VALUES(p_order_id, 'PLACED');
END$$
DELIMITER ;
