DELIMITER $$
CREATE FUNCTION last_order_action(p_order_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
  DECLARE v_action VARCHAR(50);
  SELECT action INTO v_action FROM order_log WHERE order_id = p_order_id ORDER BY log_date DESC, log_id DESC LIMIT 1;
  RETURN COALESCE(v_action,'');
END$$
DELIMITER ;
