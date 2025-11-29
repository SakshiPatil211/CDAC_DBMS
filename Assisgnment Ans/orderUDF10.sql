DELIMITER $$
CREATE FUNCTION days_since_order(p_order_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_order_date DATE;
  SELECT (SELECT MIN(log_date) FROM order_log WHERE order_id = p_order_id) INTO v_order_date;
  IF v_order_date IS NULL THEN
    RETURN NULL;
  END IF;
  RETURN DATEDIFF(CURDATE(), v_order_date);
END$$
DELIMITER ;
