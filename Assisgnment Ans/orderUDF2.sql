DELIMITER $$
CREATE FUNCTION product_cancel_count(p_product_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_cnt INT;
  SELECT COUNT(*) INTO v_cnt FROM order_log l JOIN shop_orders o ON l.order_id = o.order_id WHERE o.product_id = p_product_id AND l.action = 'CANCELLED';
  RETURN COALESCE(v_cnt,0);
END$$
DELIMITER ;
