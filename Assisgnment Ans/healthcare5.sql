DELIMITER $$
CREATE FUNCTION medicine_expense(p_patient_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
  DECLARE v_med DECIMAL(12,2);
  SELECT COALESCE(SUM(medicine_fee),0) INTO v_med FROM treatment WHERE patient_id = p_patient_id;
  RETURN v_med;
END$$
DELIMITER ;
