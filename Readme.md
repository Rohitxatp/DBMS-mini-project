# Examination Seating Allocation Database System

## Overview

This project is a DBMS-based system developed to automate the seating arrangement process for examinations. It manages students, exams, rooms, seats, and allocations while enforcing constraints to prevent conflicts such as duplicate seat assignments, room overbooking, and student allocation errors.

The system improves accuracy, saves manual effort, and ensures efficient hall management during examinations.

---

## Objectives

* Automate examination seating allocation
* Prevent duplicate seat assignments
* Avoid room over-capacity issues
* Manage multiple exams, rooms, and time slots
* Generate room-wise seating plans
* Improve fairness and reduce manual errors

---

## Features

* Student registration for exams
* Exam scheduling by date and slot
* Room and seat management
* Automatic seat allocation
* Conflict prevention using SQL constraints and triggers
* Student seat lookup
* Vacant seat tracking
* Room occupancy reports
* Invigilator duty management (optional)

---

## Database Schema

The system contains the following tables:

* **students** – Stores student details
* **courses** – Stores course/branch details
* **exams** – Exam schedule information
* **rooms** – Examination hall details
* **seats** – Individual seat mapping inside rooms
* **registrations** – Students registered for exams
* **allocations** – Final seat assignments
* **invigilators** – Faculty/staff details
* **invigilation_duty** – Invigilator room duties

---

## Tech Stack

* Database: MySQL
* Language: SQL

---

## Key Constraints Implemented

* Unique roll number for each student
* One student can get only one seat per exam
* One seat can be assigned only once per exam
* Room capacity cannot be exceeded
* Foreign key relationships for consistency

---

## Conflict Prevention Logic

Implemented using triggers / procedures:

* Prevent duplicate student allocation
* Prevent duplicate seat allocation
* Prevent room overbooking
* Prevent invigilator double-booking
* Validate room capacity before assignment

---

## How to Run

### Step 1: Create Database

```sql
CREATE DATABASE exam_seating_db;
USE exam_seating_db;
```

### Step 2: Run Files in Order

```bash
schema.sql
sample_data.sql
constraints.sql
triggers.sql
procedures.sql
queries.sql
```

---

## Sample Queries

### 1. Room Wise Seating Plan

```sql
SELECT r.room_name, s.roll_no, a.seat_id
FROM allocations a
JOIN students s ON a.student_id = s.student_id
JOIN rooms r ON a.room_id = r.room_id;
```

### 2. Student Seat Lookup

```sql
SELECT s.roll_no, e.subject_name, r.room_name, a.seat_id
FROM allocations a
JOIN students s ON a.student_id = s.student_id
JOIN exams e ON a.exam_id = e.exam_id
JOIN rooms r ON a.room_id = r.room_id;
```

### 3. Vacant Seats

```sql
SELECT seat_id
FROM seats
WHERE seat_id NOT IN (SELECT seat_id FROM allocations);
```

---

## Project Structure

```text
exam-seating-db/
│
├── schema.sql
├── sample_data.sql
├── constraints.sql
├── triggers.sql
├── procedures.sql
├── queries.sql
│
├── docs/
│   ├── ER_diagram.png
│   ├── report.pdf
│
├── README.md
```

---

## Future Enhancements

* Automatic random seating allocation
* Alternate seating for anti-cheating
* Web dashboard for admin use
* PDF admit card generation
* Attendance marking integration

---

## Learning Outcomes

* Relational database design
* Primary key / foreign key implementation
* Unique and check constraints
* Trigger-based validations
* SQL joins and reporting queries
* Real-world scheduling problem solving

---

## Author

Rohit Singh
