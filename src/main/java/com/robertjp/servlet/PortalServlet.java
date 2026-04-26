package com.robertjp.servlet;

import com.robertjp.dao.EnrollmentDAO;
import com.robertjp.dao.StudentDAO;
import com.robertjp.model.Enrollment;
import com.robertjp.model.Student;
import com.robertjp.model.User;
import com.robertjp.util.MLClient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(urlPatterns = {"/portal/home", "/portal/grades", "/portal/risk"})
public class PortalServlet extends HttpServlet {

    private StudentDAO studentDAO;
    private EnrollmentDAO enrollmentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
        enrollmentDAO = new EnrollmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        Student student = (Student) session.getAttribute("studentRecord");

        // If student record not in session, find it
        if (student == null) {
            List<Student> allStudents = studentDAO.getAllStudents();
            for (Student s : allStudents) {
                if (s.getUserId() != null && s.getUserId().equals(user.getId())) {
                    student = s;
                    session.setAttribute("studentRecord", s);
                    session.setAttribute("displayName", s.getFirstName() + " " + s.getLastName());
                    break;
                }
            }
        }

        // If still null, show error instead of redirecting
        if (student == null) {
            System.out.println("PORTAL: No student record found for user " + user.getUsername());
            request.setAttribute("error", "No student record found for your account.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String servletPath = request.getServletPath();
        String path = servletPath.replace("/portal", "");
        if (path.isEmpty()) path = "/home";

        System.out.println("PORTAL: path=" + path + " student=" + student.getFirstName());

        switch (path) {
            case "/home":
                loadDashboard(request, student);
                request.getRequestDispatcher("/portal/home.jsp").forward(request, response);
                break;

            case "/grades":
                List<Enrollment> enrollments = enrollmentDAO.getEnrollmentsByStudent(student.getId());
                request.setAttribute("enrollments", enrollments);
                BigDecimal gpa = enrollmentDAO.calculateGPA(student.getId());
                request.setAttribute("calculatedGpa", gpa);
                request.getRequestDispatcher("/portal/grades.jsp").forward(request, response);
                break;

            case "/risk":
                loadRiskAssessment(request, student);
                request.getRequestDispatcher("/portal/risk.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/portal/home");
                break;
        }
    }

    private void loadDashboard(HttpServletRequest request, Student student) {
        List<Enrollment> enrollments = enrollmentDAO.getEnrollmentsByStudent(student.getId());
        BigDecimal gpa = enrollmentDAO.calculateGPA(student.getId());

        int totalCourses = enrollments.size();
        int gradedCourses = 0;
        int totalCredits = 0;
        for (Enrollment e : enrollments) {
            totalCredits += e.getCredits();
            if (e.getGrade() != null && !e.getGrade().isEmpty()) gradedCourses++;
        }

        request.setAttribute("enrollments", enrollments);
        request.setAttribute("calculatedGpa", gpa);
        request.setAttribute("totalCourses", totalCourses);
        request.setAttribute("gradedCourses", gradedCourses);
        request.setAttribute("totalCredits", totalCredits);
    }

    private void loadRiskAssessment(HttpServletRequest request, Student student) {
        List<Enrollment> enrollments = enrollmentDAO.getEnrollmentsByStudent(student.getId());

        int coursesTaken = enrollments.size();
        int coursesFailed = 0;
        double totalGradePoints = 0;
        int gradedCount = 0;
        int totalCredits = 0;

        for (Enrollment e : enrollments) {
            totalCredits += e.getCredits();
            if (e.getGradePoints() != null) {
                totalGradePoints += e.getGradePoints().doubleValue();
                gradedCount++;
                if (e.getGradePoints().doubleValue() < 1.0) coursesFailed++;
            }
        }

        double avgGradePoints = gradedCount > 0 ? totalGradePoints / gradedCount : 0;
        double gpa = student.getGpa() != null ? student.getGpa().doubleValue() : avgGradePoints;
        int semesters = (int) enrollments.stream().map(Enrollment::getSemester).distinct().count();
        if (semesters == 0) semesters = 1;

        String prediction = MLClient.getPrediction(gpa, coursesTaken, coursesFailed,
                avgGradePoints, totalCredits, semesters);

        request.setAttribute("prediction", prediction);
    }
}