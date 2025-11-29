DELIMITER $$
CREATE FUNCTION is_out_of_stock(p_product_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  DECLARE v_stock INT;
  SELECT stock INTO v_stock FROM shop_products WHERE product_id = p_product_id;
  RETURN (v_stock <= 0);
END$$
DELIMITER ;
