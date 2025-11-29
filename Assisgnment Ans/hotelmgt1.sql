CREATE TABLE IF NOT EXISTS rooms (
  room_no INT PRIMARY KEY,
  status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE IF NOT EXISTS checkin_log (
  log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  guest_id INT,
  room_no INT,
  checkin_date DATE DEFAULT (CURDATE())
);

DELIMITER $$
CREATE PROCEDURE check_in(IN p_guest_id INT, IN p_room_no INT)
BEGIN
  DECLARE v_status VARCHAR(20);
  SELECT status INTO v_status FROM rooms WHERE room_no = p_room_no FOR UPDATE;
  IF v_status IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room not found';
  END IF;
  IF v_status <> 'Available' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room not available';
  END IF;

  UPDATE rooms SET status = 'Occupied' WHERE room_no = p_room_no;
  INSERT INTO checkin_log(guest_id, room_no) VALUES(p_guest_id, p_room_no);
END$$
DELIMITER ;
