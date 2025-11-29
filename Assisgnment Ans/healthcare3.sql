DELIMITER $$
CREATE FUNCTION patient_status(p_patient_id INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
  DECLARE v_ins VARCHAR(3);
  SELECT insurance INTO v_ins FROM patients WHERE patient_id = p_patient_id;
  IF v_ins = 'YES' THEN
    RETURN 'Insured';
  ELSE
    RETURN 'Not Insured';
  END IF;
END$$
DELIMITER ;
