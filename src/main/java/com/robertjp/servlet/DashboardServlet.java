package com.robertjp.servlet;

import com.robertjp.dao.CourseDAO;
import com.robertjp.dao.EnrollmentDAO;
import com.robertjp.dao.StudentDAO;
import com.robertjp.model.Enrollment;
import com.robertjp.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private StudentDAO studentDAO;
    private CourseDAO courseDAO;
    private EnrollmentDAO enrollmentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
        courseDAO = new CourseDAO();
        enrollmentDAO = new EnrollmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Total counts
        List<Student> students = studentDAO.getAllStudents();
        int totalStudents = students.size();
        int totalCourses = courseDAO.getAllCourses().size();
        List<Enrollment> enrollments = enrollmentDAO.getAllEnrollments();
        int totalEnrollments = enrollments.size();

        // GPA distribution
        int gpaA = 0, gpaB = 0, gpaC = 0, gpaD = 0, gpaF = 0;
        for (Enrollment e : enrollments) {
            if (e.getGradePoints() == null) continue;
            double gp = e.getGradePoints().doubleValue();
            if (gp >= 3.67) gpaA++;
            else if (gp >= 2.67) gpaB++;
            else if (gp >= 1.67) gpaC++;
            else if (gp >= 1.00) gpaD++;
            else gpaF++;
        }

        // Grades count for graded vs ungraded
        int graded = 0, ungraded = 0;
        for (Enrollment e : enrollments) {
            if (e.getGrade() != null && !e.getGrade().isEmpty()) graded++;
            else ungraded++;
        }

        // Enrollments per course
        Map<String, Integer> courseEnrollments = new HashMap<>();
        for (Enrollment e : enrollments) {
            String code = e.getCourseCode();
            courseEnrollments.put(code, courseEnrollments.getOrDefault(code, 0) + 1);
        }

        // Major distribution
        Map<String, Integer> majorDistribution = new HashMap<>();
        for (Student s : students) {
            String major = s.getMajor() != null ? s.getMajor() : "Undeclared";
            majorDistribution.put(major, majorDistribution.getOrDefault(major, 0) + 1);
        }

        // Calculate average GPA across all students
        BigDecimal totalGpa = BigDecimal.ZERO;
        int gpaCount = 0;
        for (Student s : students) {
            BigDecimal studentGpa = enrollmentDAO.calculateGPA(s.getId());
            if (studentGpa.compareTo(BigDecimal.ZERO) > 0) {
                totalGpa = totalGpa.add(studentGpa);
                gpaCount++;
            }
        }
        String avgGpa = gpaCount > 0 ?
                totalGpa.divide(new BigDecimal(gpaCount), 2, BigDecimal.ROUND_HALF_UP).toString() : "N/A";

        // Set attributes
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalCourses", totalCourses);
        request.setAttribute("totalEnrollments", totalEnrollments);
        request.setAttribute("avgGpa", avgGpa);
        request.setAttribute("gpaA", gpaA);
        request.setAttribute("gpaB", gpaB);
        request.setAttribute("gpaC", gpaC);
        request.setAttribute("gpaD", gpaD);
        request.setAttribute("gpaF", gpaF);
        request.setAttribute("graded", graded);
        request.setAttribute("ungraded", ungraded);
        request.setAttribute("courseEnrollments", courseEnrollments);
        request.setAttribute("majorDistribution", majorDistribution);

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}