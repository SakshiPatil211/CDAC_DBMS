DELIMITER $$
CREATE PROCEDURE update_order_qty(IN p_order_id INT, IN p_new_qty INT)
BEGIN
  DECLARE v_old_qty INT;
  DECLARE v_prod INT;
  SELECT qty, product_id INTO v_old_qty, v_prod FROM shop_orders WHERE order_id = p_order_id FOR UPDATE;
  IF v_old_qty IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order not found';
  END IF;
  -- adjust stock: if new qty > old -> reduce more stock; if new qty < old -> add back difference
  IF p_new_qty > v_old_qty THEN
    UPDATE shop_products SET stock = stock - (p_new_qty - v_old_qty) WHERE product_id = v_prod;
  ELSE
    UPDATE shop_products SET stock = stock + (v_old_qty - p_new_qty) WHERE product_id = v_prod;
  END IF;

  UPDATE shop_orders SET qty = p_new_qty WHERE order_id = p_order_id;
  INSERT INTO order_log(order_id, action) VALUES(p_order_id, CONCAT('QTY_UPDATED_TO_', p_new_qty));
END$$
DELIMITER ;

