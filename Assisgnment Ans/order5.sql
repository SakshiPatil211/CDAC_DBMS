DELIMITER $$
CREATE PROCEDURE add_product(IN p_product_id INT, IN p_name VARCHAR(50), IN p_stock INT)
BEGIN
  INSERT INTO shop_products(product_id, product_name, stock) VALUES(p_product_id, p_name, p_stock);
END$$
DELIMITER ;
