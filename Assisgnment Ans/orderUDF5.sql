DELIMITER $$
CREATE FUNCTION first_order_action(p_order_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
  DECLARE v_action VARCHAR(50);
  SELECT action INTO v_action FROM order_log WHERE order_id = p_order_id ORDER BY log_date ASC, log_id ASC LIMIT 1;
  RETURN COALESCE(v_action,'');
END$$
DELIMITER ;

