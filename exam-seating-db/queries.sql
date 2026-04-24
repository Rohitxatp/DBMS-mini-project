-- queries.sql
USE exam_seating;

-- 1. Room-wise seating chart
SELECT 
    r.room_number,
    s.row_num,
    s.col_num,
    st.roll_no,
    st.first_name,
    st.last_name,
    c.course_code
FROM allocations a
JOIN seats s ON a.seat_id = s.seat_id
JOIN rooms r ON s.room_id = r.room_id
JOIN students st ON a.student_id = st.student_id
JOIN exams e ON a.exam_id = e.exam_id
JOIN courses c ON e.course_id = c.course_id
WHERE a.exam_id = 1 
ORDER BY r.room_number, s.row_num, s.col_num;


-- 2. Student seat lookup (Where is a specific student sitting?)
SELECT 
    st.roll_no,
    c.course_name,
    e.exam_date,
    e.start_time,
    e.end_time,
    r.room_number,
    s.row_num,
    s.col_num
FROM allocations a
JOIN students st ON a.student_id = st.student_id
JOIN exams e ON a.exam_id = e.exam_id
JOIN courses c ON e.course_id = c.course_id
JOIN seats s ON a.seat_id = s.seat_id
JOIN rooms r ON s.room_id = r.room_id
WHERE st.roll_no = 'CS2023001' AND c.course_code = 'CS101';


-- 3. Vacant seats (For a specific Exam in a specific Room)
SELECT 
    r.room_number,
    s.seat_id,
    s.row_num,
    s.col_num
FROM seats s
JOIN rooms r ON s.room_id = r.room_id
WHERE r.room_number = '101A' 
  AND s.seat_id NOT IN (
      SELECT seat_id FROM allocations WHERE exam_id = 1
  );


-- 4. Occupancy percentage for an Exam across multiple rooms
SELECT 
    r.room_number,
    r.capacity AS total_capacity,
    COUNT(a.seat_id) AS occupied_seats,
    CAST((COUNT(a.seat_id) / r.capacity) * 100 AS DECIMAL(5,2)) AS occupancy_percentage
FROM rooms r
JOIN seats s ON r.room_id = s.room_id
LEFT JOIN allocations a ON s.seat_id = a.seat_id AND a.exam_id = 1
GROUP BY r.room_id, r.room_number, r.capacity;


-- 5. Clash report (Students who are registered for exams that overlap in time and date)
SELECT 
    st.roll_no,
    CONCAT(st.first_name, ' ', st.last_name) AS student_name,
    c1.course_code AS clash_course_1,
    e1.start_time AS course_1_start,
    e1.end_time AS course_1_end,
    c2.course_code AS clash_course_2,
    e2.start_time AS course_2_start,
    e2.end_time AS course_2_end,
    e1.exam_date AS clash_date
FROM registrations reg1
JOIN registrations reg2 ON reg1.student_id = reg2.student_id AND reg1.course_id < reg2.course_id
JOIN students st ON reg1.student_id = st.student_id
JOIN exams e1 ON reg1.course_id = e1.course_id
JOIN exams e2 ON reg2.course_id = e2.course_id
JOIN courses c1 ON e1.course_id = c1.course_id
JOIN courses c2 ON e2.course_id = c2.course_id
WHERE e1.exam_date = e2.exam_date
  AND (
      (e1.start_time >= e2.start_time AND e1.start_time < e2.end_time) OR
      (e1.end_time > e2.start_time AND e1.end_time <= e2.end_time) OR
      (e1.start_time <= e2.start_time AND e1.end_time >= e2.end_time)
  );
