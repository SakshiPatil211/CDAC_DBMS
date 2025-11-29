DELIMITER $$
CREATE PROCEDURE cancel_order(IN p_order_id INT)
BEGIN
  DECLARE v_status VARCHAR(20);
  DECLARE v_prod INT;
  DECLARE v_qty INT;

  SELECT status, product_id, qty INTO v_status, v_prod, v_qty FROM shop_orders WHERE order_id = p_order_id FOR UPDATE;
  IF v_status IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order not found';
  END IF;

  IF v_status = 'CANCELLED' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order already cancelled';
  END IF;

  -- Update stock
  UPDATE shop_products SET stock = stock + v_qty WHERE product_id = v_prod;
  -- Update order status
  UPDATE shop_orders SET status = 'CANCELLED' WHERE order_id = p_order_id;
  -- Log
  INSERT INTO order_log(order_id, action) VALUES(p_order_id, 'CANCELLED');
END$$
DELIMITER ;
