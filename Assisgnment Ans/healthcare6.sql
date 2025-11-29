DELIMITER $$
CREATE FUNCTION doctor_expense(p_patient_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
  DECLARE v_doc DECIMAL(12,2);
  SELECT COALESCE(SUM(doctor_fee),0) INTO v_doc FROM treatment WHERE patient_id = p_patient_id;
  RETURN v_doc;
END$$
DELIMITER ;
