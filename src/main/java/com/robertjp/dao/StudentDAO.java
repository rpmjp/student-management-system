package com.robertjp.dao;

import com.robertjp.model.Student;
import com.robertjp.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    // CREATE - Insert a new student
    public boolean addStudent(Student student) {
        String sql = "INSERT INTO students (user_id, student_id, first_name, last_name, email, major, gpa, enrollment_date) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (student.getUserId() != null) {
                stmt.setInt(1, student.getUserId());
            } else {
                stmt.setNull(1, java.sql.Types.INTEGER);
            }
            stmt.setString(2, student.getStudentId());
            stmt.setString(3, student.getFirstName());
            stmt.setString(4, student.getLastName());
            stmt.setString(5, student.getEmail());
            stmt.setString(6, student.getMajor());
            stmt.setBigDecimal(7, student.getGpa());
            stmt.setDate(8, Date.valueOf(student.getEnrollmentDate()));

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // READ - Get all students
    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setUserId(rs.getObject("user_id") != null ? rs.getInt("user_id") : null);
                student.setStudentId(rs.getString("student_id"));
                student.setFirstName(rs.getString("first_name"));
                student.setLastName(rs.getString("last_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setGpa(rs.getBigDecimal("gpa"));
                student.setEnrollmentDate(rs.getDate("enrollment_date").toLocalDate());
                student.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return students;
    }

    // READ - Get a single student by ID
    public Student getStudentById(int id) {
        String sql = "SELECT * FROM students WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setFirstName(rs.getString("first_name"));
                student.setLastName(rs.getString("last_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setGpa(rs.getBigDecimal("gpa"));
                student.setEnrollmentDate(rs.getDate("enrollment_date").toLocalDate());
                student.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                return student;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // UPDATE - Edit a student
    public boolean updateStudent(Student student) {
        String sql = "UPDATE students SET first_name = ?, last_name = ?, email = ?, " +
                "major = ?, gpa = ?, enrollment_date = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, student.getFirstName());
            stmt.setString(2, student.getLastName());
            stmt.setString(3, student.getEmail());
            stmt.setString(4, student.getMajor());
            stmt.setBigDecimal(5, student.getGpa());
            stmt.setDate(6, Date.valueOf(student.getEnrollmentDate()));
            stmt.setInt(7, student.getId());

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE - Remove a student
    public boolean deleteStudent(int id) {
        String sql = "DELETE FROM students WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // SEARCH - Find students by name or email
    public List<Student> searchStudents(String keyword) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students WHERE first_name LIKE ? OR last_name LIKE ? " +
                "OR email LIKE ? OR major LIKE ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchTerm = "%" + keyword + "%";
            stmt.setString(1, searchTerm);
            stmt.setString(2, searchTerm);
            stmt.setString(3, searchTerm);
            stmt.setString(4, searchTerm);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setUserId(rs.getObject("user_id") != null ? rs.getInt("user_id") : null);
                student.setStudentId(rs.getString("student_id"));
                student.setFirstName(rs.getString("first_name"));
                student.setLastName(rs.getString("last_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setGpa(rs.getBigDecimal("gpa"));
                student.setEnrollmentDate(rs.getDate("enrollment_date").toLocalDate());
                student.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                students.add(student);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }
}