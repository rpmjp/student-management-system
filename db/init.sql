USE student_management;

CREATE TABLE IF NOT EXISTS students (
                                        id INT AUTO_INCREMENT PRIMARY KEY,
                                        user_id INT UNIQUE,
                                        student_id VARCHAR(20) UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    major VARCHAR(100),
    gpa DECIMAL(3,2),
    enrollment_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE IF NOT EXISTS courses (
                                       id INT AUTO_INCREMENT PRIMARY KEY,
                                       course_code VARCHAR(20) NOT NULL UNIQUE,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE IF NOT EXISTS enrollments (
                                           id INT AUTO_INCREMENT PRIMARY KEY,
                                           student_id INT NOT NULL,
                                           course_id INT NOT NULL,
                                           semester VARCHAR(20) NOT NULL,
    grade VARCHAR(2),
    grade_points DECIMAL(3,2),
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (student_id, course_id, semester)
    );

CREATE TABLE IF NOT EXISTS users (
                                     id INT AUTO_INCREMENT PRIMARY KEY,
                                     username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'STAFF', 'STUDENT') NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE IF NOT EXISTS staff (
                                     id INT AUTO_INCREMENT PRIMARY KEY,
                                     user_id INT NOT NULL UNIQUE,
                                     first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    department VARCHAR(100),
    title VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );

ALTER TABLE students ADD FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;

-- Create admin account
INSERT INTO users (username, password_hash, role) VALUES
    ('admin', SHA2('Admin123!', 256), 'ADMIN');

INSERT INTO staff (user_id, first_name, last_name, email, department, title) VALUES
    (1, 'Admin', 'User', 'admin@school.edu', 'IT', 'System Administrator');

-- Sample data
INSERT INTO students (first_name, last_name, email, major, gpa, enrollment_date) VALUES
                                                                                     ('Alice', 'Johnson', 'alice@school.edu', 'Computer Science', 3.85, '2024-09-01'),
                                                                                     ('Marcus', 'Williams', 'marcus@school.edu', 'Data Science', 3.42, '2024-09-01'),
                                                                                     ('Sarah', 'Chen', 'sarah@school.edu', 'Computer Science', 3.91, '2025-01-15');

INSERT INTO courses (course_code, course_name, credits, description) VALUES
                                                                         ('CS602', 'Java Web Programming', 3, 'Server-side Java development with servlets and JSP'),
                                                                         ('CS644', 'Introduction to Big Data', 3, 'Hadoop, MapReduce, and distributed computing'),
                                                                         ('CS732', 'Advanced Machine Learning', 3, 'Deep learning theory and applications');