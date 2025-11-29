DELIMITER $$
CREATE TRIGGER trg_products_after_insert
AFTER INSERT ON products
FOR EACH ROW
BEGIN
  -- If discount_pct is NULL, assign a random discount 5..30
  IF NEW.discount_pct IS NULL THEN
    UPDATE products
    SET discount_pct = FLOOR(RAND() * 26) + 5
    WHERE product_id = NEW.product_id;
  END IF;
END$$
DELIMITER ;
