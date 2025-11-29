CREATE TABLE IF NOT EXISTS student_batch (
  student_id INT PRIMARY KEY,
  batch CHAR(1)
);

DELIMITER $$
CREATE PROCEDURE assign_random_batches(IN p_course_id INT)
BEGIN
  -- Assign A/B/C randomly for students of given course
  INSERT INTO student_batch(student_id, batch)
  SELECT s.student_id,
         CASE FLOOR(RAND()*3) WHEN 0 THEN 'A' WHEN 1 THEN 'B' ELSE 'C' END
  FROM student_academic s
  WHERE s.course_id = p_course_id
  ON DUPLICATE KEY UPDATE batch = VALUES(batch);
END$$
DELIMITER ;
