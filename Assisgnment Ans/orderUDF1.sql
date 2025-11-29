DELIMITER $$
CREATE FUNCTION check_order_status(p_order_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
  DECLARE v_status VARCHAR(20);
  SELECT status INTO v_status FROM shop_orders WHERE order_id = p_order_id;
  IF v_status IS NULL THEN
    RETURN 'Order not found';
  END IF;
  IF v_status = 'CANCELLED' THEN
    RETURN 'Order already cancelled';
  ELSEIF v_status = 'PLACED' THEN
    RETURN 'Order can be cancelled';
  ELSE
    RETURN CONCAT('Status=', v_status);
  END IF;
END$$
DELIMITER ;
