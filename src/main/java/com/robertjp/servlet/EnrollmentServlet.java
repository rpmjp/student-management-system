package com.robertjp.servlet;

import com.robertjp.dao.CourseDAO;
import com.robertjp.dao.EnrollmentDAO;
import com.robertjp.dao.StudentDAO;
import com.robertjp.model.Enrollment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/enrollments")
public class EnrollmentServlet extends HttpServlet {

    private EnrollmentDAO enrollmentDAO;
    private StudentDAO studentDAO;
    private CourseDAO courseDAO;

    @Override
    public void init() {
        enrollmentDAO = new EnrollmentDAO();
        studentDAO = new StudentDAO();
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
                enrollmentDAO.deleteEnrollment(deleteId);
                response.sendRedirect("enrollments");
                break;

            default:
                List<Enrollment> enrollments = enrollmentDAO.getAllEnrollments();
                request.setAttribute("enrollments", enrollments);
                request.setAttribute("students", studentDAO.getAllStudents());
                request.setAttribute("courses", courseDAO.getAllCourses());
                request.getRequestDispatcher("/enrollments.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("grade".equals(action)) {
            int enrollmentId = Integer.parseInt(request.getParameter("enrollmentId"));
            String grade = request.getParameter("grade");
            BigDecimal gradePoints = getGradePoints(grade);
            enrollmentDAO.updateGrade(enrollmentId, grade, gradePoints);
        } else {
            Enrollment enrollment = new Enrollment();
            enrollment.setStudentId(Integer.parseInt(request.getParameter("studentId")));
            enrollment.setCourseId(Integer.parseInt(request.getParameter("courseId")));
            enrollment.setSemester(request.getParameter("semester"));

            String grade = request.getParameter("grade");
            if (grade != null && !grade.isEmpty()) {
                enrollment.setGrade(grade);
                enrollment.setGradePoints(getGradePoints(grade));
            }

            enrollmentDAO.enrollStudent(enrollment);
        }

        response.sendRedirect("enrollments");
    }

    // Converts letter grade to grade points
    private BigDecimal getGradePoints(String grade) {
        if (grade == null || grade.isEmpty()) return null;
        switch (grade.toUpperCase()) {
            case "A":  return new BigDecimal("4.00");
            case "A-": return new BigDecimal("3.67");
            case "B+": return new BigDecimal("3.33");
            case "B":  return new BigDecimal("3.00");
            case "B-": return new BigDecimal("2.67");
            case "C+": return new BigDecimal("2.33");
            case "C":  return new BigDecimal("2.00");
            case "C-": return new BigDecimal("1.67");
            case "D+": return new BigDecimal("1.33");
            case "D":  return new BigDecimal("1.00");
            case "F":  return new BigDecimal("0.00");
            default:   return null;
        }
    }
}