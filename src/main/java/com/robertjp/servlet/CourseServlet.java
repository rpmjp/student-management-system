package com.robertjp.servlet;

import com.robertjp.dao.CourseDAO;
import com.robertjp.model.Course;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/courses")
public class CourseServlet extends HttpServlet {

    private CourseDAO courseDAO;

    @Override
    public void init() {
        courseDAO = new CourseDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                courseDAO.deleteCourse(deleteId);
                response.sendRedirect("courses");
                break;

            default:
                List<Course> courses = courseDAO.getAllCourses();
                request.setAttribute("courses", courses);
                request.getRequestDispatcher("/courses.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String courseCode = request.getParameter("courseCode").trim();
        String courseName = request.getParameter("courseName").trim();
        String creditsStr = request.getParameter("credits");
        String description = request.getParameter("description").trim();

        // Validation
        StringBuilder errors = new StringBuilder();

        if (courseCode.isEmpty() || courseCode.length() > 20) {
            errors.append("Course code is required and must be under 20 characters. ");
        }
        if (courseName.isEmpty() || courseName.length() > 100) {
            errors.append("Course name is required and must be under 100 characters. ");
        }

        int credits;
        try {
            credits = Integer.parseInt(creditsStr);
            if (credits < 1 || credits > 6) {
                errors.append("Credits must be between 1 and 6. ");
            }
        } catch (NumberFormatException e) {
            errors.append("Invalid credits. ");
            credits = 3;
        }

        // Sanitize
        courseCode = sanitize(courseCode);
        courseName = sanitize(courseName);
        description = sanitize(description);

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString());
            request.setAttribute("courses", courseDAO.getAllCourses());
            request.getRequestDispatcher("/courses.jsp").forward(request, response);
            return;
        }

        Course course = new Course(courseCode, courseName, credits, description);
        courseDAO.addCourse(course);

        response.sendRedirect(request.getContextPath() + "/courses");
    }

    private String sanitize(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
}