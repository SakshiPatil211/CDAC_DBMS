DELIMITER $$
CREATE FUNCTION get_order_status(p_order_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
  DECLARE v_status VARCHAR(20);
  SELECT status INTO v_status FROM shop_orders WHERE order_id = p_order_id;
  RETURN COALESCE(v_status,'NOT_FOUND');
END$$
DELIMITER ;
