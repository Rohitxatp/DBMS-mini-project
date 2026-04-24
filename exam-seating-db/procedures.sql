-- procedures.sql
USE exam_seating;

DELIMITER $$

-- Procedure to allocate a seat with basic transactional safety
CREATE PROCEDURE AllocateStudentToSeat(
    IN p_exam_id INT,
    IN p_student_id INT,
    IN p_seat_id INT
)
BEGIN
    DECLARE v_is_registered INT;
    DECLARE v_course_id INT;

    -- Find the course for the given exam
    SELECT course_id INTO v_course_id FROM exams WHERE exam_id = p_exam_id;

    -- Ensure the student is registered for the course associated with the exam
    SELECT COUNT(*) INTO v_is_registered
    FROM registrations
    WHERE student_id = p_student_id AND course_id = v_course_id;

    IF v_is_registered = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Student is not registered for the course related to this exam.';
    END IF;

    -- Try inserting the allocation (Triggers and Constraints handle the actual duplication & overbooking checks)
    INSERT INTO allocations (exam_id, student_id, seat_id)
    VALUES (p_exam_id, p_student_id, p_seat_id);

    SELECT 'Student allocated successfully!' AS Message;
END$$

-- Procedure to bulk add seats for a room
CREATE PROCEDURE GenerateseatsForRoom(
    IN p_room_id INT,
    IN p_rows INT,
    IN p_cols INT
)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE j INT DEFAULT 1;
    
    WHILE i <= p_rows DO
        SET j = 1;
        WHILE j <= p_cols DO
             INSERT IGNORE INTO seats (room_id, row_num, col_num) VALUES (p_room_id, i, j);
             SET j = j + 1;
        END WHILE;
        SET i = i + 1;
    END WHILE;
    
    SELECT CONCAT('Seats generated for room ID: ', p_room_id) AS Message;
END$$

DELIMITER ;
