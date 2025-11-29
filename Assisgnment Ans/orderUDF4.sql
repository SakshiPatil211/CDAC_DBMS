DELIMITER $$
CREATE FUNCTION product_cancelled_qty(p_product_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_qty INT;
  SELECT COALESCE(SUM(o.qty),0) INTO v_qty
  FROM shop_orders o
  JOIN order_log l ON o.order_id = l.order_id
  WHERE o.product_id = p_product_id AND l.action = 'CANCELLED';
  RETURN v_qty;
END$$
DELIMITER ;
