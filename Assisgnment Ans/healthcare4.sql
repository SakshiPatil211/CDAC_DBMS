DELIMITER $$
CREATE FUNCTION highest_bill_patient()
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_pid INT;
  SELECT patient_id
  FROM (
    SELECT patient_id, SUM(doctor_fee + medicine_fee) AS total
    FROM treatment
    GROUP BY patient_id
    ORDER BY total DESC
    LIMIT 1
  ) t INTO v_pid;
  RETURN v_pid;
END$$
DELIMITER ;
