DELIMITER $$
CREATE PROCEDURE get_orders_for_product(IN p_product_id INT)
BEGIN
  SELECT * FROM shop_orders WHERE product_id = p_product_id;
END$$
DELIMITER ;
