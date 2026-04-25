package com.robertjp.dao;

import com.robertjp.model.Enrollment;
import com.robertjp.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EnrollmentDAO {

    public boolean enrollStudent(Enrollment enrollment) {
        String sql = "INSERT INTO enrollments (student_id, course_id, semester, grade, grade_points) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, enrollment.getStudentId());
            stmt.setInt(2, enrollment.getCourseId());
            stmt.setString(3, enrollment.getSemester());
            stmt.setString(4, enrollment.getGrade());
            if (enrollment.getGradePoints() != null) {
                stmt.setBigDecimal(5, enrollment.getGradePoints());
            } else {
                stmt.setNull(5, Types.DECIMAL);
            }

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // This is the JOIN query - combines data from 3 tables
    public List<Enrollment> getEnrollmentsByStudent(int studentId) {
        List<Enrollment> enrollments = new ArrayList<>();
        String sql = "SELECT e.*, " +
                "CONCAT(s.first_name, ' ', s.last_name) AS student_name, " +
                "c.course_code, c.course_name, c.credits " +
                "FROM enrollments e " +
                "JOIN students s ON e.student_id = s.id " +
                "JOIN courses c ON e.course_id = c.id " +
                "WHERE e.student_id = ? " +
                "ORDER BY e.semester DESC, c.course_code";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Enrollment enrollment = buildEnrollment(rs);
                enrollments.add(enrollment);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return enrollments;
    }

    public List<Enrollment> getAllEnrollments() {
        List<Enrollment> enrollments = new ArrayList<>();
        String sql = "SELECT e.*, " +
                "CONCAT(s.first_name, ' ', s.last_name) AS student_name, " +
                "c.course_code, c.course_name, c.credits " +
                "FROM enrollments e " +
                "JOIN students s ON e.student_id = s.id " +
                "JOIN courses c ON e.course_id = c.id " +
                "ORDER BY e.semester DESC, student_name, c.course_code";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Enrollment enrollment = buildEnrollment(rs);
                enrollments.add(enrollment);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return enrollments;
    }

    public boolean updateGrade(int enrollmentId, String grade, BigDecimal gradePoints) {
        String sql = "UPDATE enrollments SET grade = ?, grade_points = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, grade);
            stmt.setBigDecimal(2, gradePoints);
            stmt.setInt(3, enrollmentId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteEnrollment(int id) {
        String sql = "DELETE FROM enrollments WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Calculate GPA for a student
    public BigDecimal calculateGPA(int studentId) {
        String sql = "SELECT SUM(e.grade_points * c.credits) / SUM(c.credits) AS gpa " +
                "FROM enrollments e " +
                "JOIN courses c ON e.course_id = c.id " +
                "WHERE e.student_id = ? AND e.grade_points IS NOT NULL";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                BigDecimal gpa = rs.getBigDecimal("gpa");
                if (gpa != null) {
                    return gpa.setScale(2, BigDecimal.ROUND_HALF_UP);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    // Helper method to avoid repeating code
    private Enrollment buildEnrollment(ResultSet rs) throws SQLException {
        Enrollment enrollment = new Enrollment();
        enrollment.setId(rs.getInt("id"));
        enrollment.setStudentId(rs.getInt("student_id"));
        enrollment.setCourseId(rs.getInt("course_id"));
        enrollment.setSemester(rs.getString("semester"));
        enrollment.setGrade(rs.getString("grade"));
        enrollment.setGradePoints(rs.getBigDecimal("grade_points"));
        enrollment.setEnrolledAt(rs.getTimestamp("enrolled_at").toLocalDateTime());
        enrollment.setStudentName(rs.getString("student_name"));
        enrollment.setCourseCode(rs.getString("course_code"));
        enrollment.setCourseName(rs.getString("course_name"));
        enrollment.setCredits(rs.getInt("credits"));
        return enrollment;
    }
}