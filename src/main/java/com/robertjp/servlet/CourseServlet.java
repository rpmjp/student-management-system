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

        String courseCode = request.getParameter("courseCode");
        String courseName = request.getParameter("courseName");
        int credits = Integer.parseInt(request.getParameter("credits"));
        String description = request.getParameter("description");

        Course course = new Course(courseCode, courseName, credits, description);
        courseDAO.addCourse(course);

        response.sendRedirect("courses");
    }
}