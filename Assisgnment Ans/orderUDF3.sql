DELIMITER $$
CREATE FUNCTION get_stock(p_product_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_stock INT;
  SELECT stock INTO v_stock FROM shop_products WHERE product_id = p_product_id;
  RETURN COALESCE(v_stock,0);
END$$
DELIMITER ;
