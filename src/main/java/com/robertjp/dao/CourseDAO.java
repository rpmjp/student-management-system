package com.robertjp.dao;

import com.robertjp.model.Course;
import com.robertjp.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {

    public boolean addCourse(Course course) {
        String sql = "INSERT INTO courses (course_code, course_name, credits, description) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, course.getCourseCode());
            stmt.setString(2, course.getCourseName());
            stmt.setInt(3, course.getCredits());
            stmt.setString(4, course.getDescription());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Course> getAllCourses() {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM courses ORDER BY course_code";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("id"));
                course.setCourseCode(rs.getString("course_code"));
                course.setCourseName(rs.getString("course_name"));
                course.setCredits(rs.getInt("credits"));
                course.setDescription(rs.getString("description"));
                course.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                courses.add(course);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public Course getCourseById(int id) {
        String sql = "SELECT * FROM courses WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("id"));
                course.setCourseCode(rs.getString("course_code"));
                course.setCourseName(rs.getString("course_name"));
                course.setCredits(rs.getInt("credits"));
                course.setDescription(rs.getString("description"));
                course.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                return course;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteCourse(int id) {
        String sql = "DELETE FROM courses WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}