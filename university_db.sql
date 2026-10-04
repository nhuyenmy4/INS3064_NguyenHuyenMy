-- =================================================================================
-- Student Name: Nguyễn Huyền My
-- Student ID: 23070626
-- Assignment: INS3064 — Homework 4 (University Course Registration System)
-- =================================================================================

DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE university_db;

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS semesters;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS departments;

-- 1. Table: departments (Cấu trúc ban đầu)
CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    department_code VARCHAR(20) NOT NULL UNIQUE,
    department_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Table: instructors
CREATE TABLE instructors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    instructor_code VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    gender ENUM('Male', 'Female', 'Other') DEFAULT 'Other',
    department_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. Table: students
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_code VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    dob DATE,
    gpa DECIMAL(3,2) DEFAULT 0.00,
    department_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_gpa CHECK (gpa >= 0.00 AND gpa <= 4.00),
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4. Table: semesters
CREATE TABLE semesters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    semester_code VARCHAR(20) NOT NULL UNIQUE,
    semester_name VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_dates CHECK (end_date > start_date)
) ENGINE=InnoDB;

-- 5. Table: courses
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(150) NOT NULL,
    credits INT NOT NULL,
    department_id INT NOT NULL,
    instructor_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_credits CHECK (credits > 0),
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES instructors(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. Table: enrollments
CREATE TABLE enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester_id INT NOT NULL,
    enrollment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    grade DECIMAL(3,2),
    grade_letter ENUM('A', 'B', 'C', 'D', 'F'),
    UNIQUE KEY unique_enrollment (student_id, course_id, semester_id),
    CONSTRAINT chk_course_grade CHECK (grade >= 0.00 AND grade <= 4.00),
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =================================================================================
-- INSERT SAMPLE DATA (Thông tin VNU-IS)
-- =================================================================================

-- Chèn 5 Khoa / Bộ môn (Giữ 5 khoa của VNU-IS nhưng bỏ địa chỉ/sdt)
INSERT INTO departments (department_code, department_name, description) VALUES
('IS', 'Khoa Các khoa học ứng dụng', 'Phụ trách môn Lập trình, Hệ thống thông tin'),
('ECO', 'Khoa Kinh tế và Quản lý', 'Phụ trách môn Kinh tế vĩ mô, Quản trị KD'),
('LANG', 'Khoa Ngôn ngữ ứng dụng', 'Phụ trách các môn Ngoại ngữ'),
('BASIC', 'Bộ môn Khoa học cơ bản', 'Phụ trách Toán, Chính trị, Pháp luật'),
('SKILL', 'Bộ môn Kỹ năng bổ trợ', 'Phụ trách Kỹ năng mềm');

-- Chèn 5 Giảng viên
INSERT INTO instructors (instructor_code, full_name, email, gender, department_id) VALUES
('GV001', 'Nguyễn Tiến Dũng', 'dung.nt@vnu.edu.vn', 'Male', 1),
('GV002', 'Trần Thị Mai', 'mai.tt@vnu.edu.vn', 'Female', 2),
('GV003', 'Lê Bích Ngọc', 'ngoc.lb@vnu.edu.vn', 'Female', 4),
('GV004', 'Phạm Quốc Hùng', 'hung.pq@vnu.edu.vn', 'Male', 5),
('GV005', 'Hoàng Minh Tuấn', 'tuan.hm@vnu.edu.vn', 'Male', 1);

-- Chèn 5 Sinh viên VNU-IS (Khóa 23)
INSERT INTO students (student_code, full_name, email, gender, dob, gpa, department_id) VALUES
('23070626', 'Lê Hải Đăng', '23070626@vnu.edu.vn', 'Male', '2005-05-15', 3.20, 1),
('23070627', 'Nguyễn Quỳnh Anh', '23070627@vnu.edu.vn', 'Female', '2005-10-20', 3.85, 2),
('23070628', 'Trần Bảo Long', '23070628@vnu.edu.vn', 'Male', '2005-02-28', 2.90, 1),
('23070629', 'Vũ Thảo My', '23070629@vnu.edu.vn', 'Female', '2005-07-12', 3.50, 1),
('23070630', 'Đinh Đức Trọng', '23070630@vnu.edu.vn', 'Male', '2005-11-05', 3.10, 2);

-- Chèn 5 Học kỳ
INSERT INTO semesters (semester_code, semester_name, start_date, end_date) VALUES
('FALL2023', 'Mùa Thu 2023', '2023-09-05', '2024-01-15'),
('SPRING2024', 'Mùa Xuân 2024', '2024-02-15', '2024-06-30'),
('SUMMER2024', 'Mùa Hè 2024', '2024-07-10', '2024-08-30'),
('FALL2024', 'Mùa Thu 2024', '2024-09-05', '2025-01-15'),
('SPRING2025', 'Mùa Xuân 2025', '2025-02-15', '2025-06-30');

-- Chèn các Môn học (Theo khung chương trình)
INSERT INTO courses (course_code, title, credits, department_id, instructor_id) VALUES
('INE1051', 'Kinh tế vĩ mô', 3, 2, 2), 
('INS2020', 'Lập trình 1', 3, 1, 1), 
('INS2111', 'Tổ chức và quản trị kinh doanh', 3, 2, 2), 
('MAT1004', 'Lí thuyết xác suất và thống kê toán', 3, 4, 3), 
('PEC1008', 'Kinh tế chính trị Mác - Lênin', 2, 4, 3), 
('ISV1023', 'Kĩ năng bổ trợ 2', 1, 5, 4);

-- Chèn 10 Đăng ký học (Enrollments)
INSERT INTO enrollments (student_id, course_id, semester_id, grade, grade_letter) VALUES
(1, 2, 4, 3.50, 'B'),
(1, 4, 4, 4.00, 'A'),
(2, 1, 4, 3.80, 'A'),
(2, 3, 4, 4.00, 'A'),
(3, 2, 4, 2.50, 'C'),
(4, 2, 4, 3.80, 'A'),
(5, 5, 4, 3.20, 'B'),
(1, 6, 2, 2.00, 'D'),
(3, 1, 5, NULL, NULL),
(5, 3, 5, NULL, NULL);