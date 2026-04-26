package com.robertjp.servlet;

import com.robertjp.util.MLClient;
import com.robertjp.dao.EnrollmentDAO;

import com.robertjp.dao.StudentDAO;
import com.robertjp.model.Student;

import com.robertjp.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/students")
public class StudentServlet extends HttpServlet {

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "predict":
                int predictId = Integer.parseInt(request.getParameter("id"));
                Student predictStudent = studentDAO.getStudentById(predictId);
                EnrollmentDAO enrollDAO = new EnrollmentDAO();

                // Gather student data for prediction
                var enrollments = enrollDAO.getEnrollmentsByStudent(predictId);
                int coursesTaken = enrollments.size();
                int coursesFailed = 0;
                double totalGradePoints = 0;
                int gradedCount = 0;
                int totalCredits = 0;

                for (var e : enrollments) {
                    totalCredits += e.getCredits();
                    if (e.getGradePoints() != null) {
                        totalGradePoints += e.getGradePoints().doubleValue();
                        gradedCount++;
                        if (e.getGradePoints().doubleValue() < 1.0) coursesFailed++;
                    }
                }

                double avgGradePoints = gradedCount > 0 ? totalGradePoints / gradedCount : 0;
                double gpa = predictStudent.getGpa() != null ? predictStudent.getGpa().doubleValue() : avgGradePoints;
                int semesters = (int) enrollments.stream().map(e -> e.getSemester()).distinct().count();
                if (semesters == 0) semesters = 1;

                String prediction = MLClient.getPrediction(gpa, coursesTaken, coursesFailed,
                        avgGradePoints, totalCredits, semesters);

                request.setAttribute("prediction", prediction);
                request.setAttribute("predictStudent", predictStudent);
                request.setAttribute("students", studentDAO.getAllStudents());
                request.getRequestDispatcher("/students.jsp").forward(request, response);
                break;

            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                Student editStudent = studentDAO.getStudentById(editId);
                request.setAttribute("editStudent", editStudent);
                request.setAttribute("students", studentDAO.getAllStudents());
                request.getRequestDispatcher("/students.jsp").forward(request, response);
                break;

            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                studentDAO.deleteStudent(deleteId);
                response.sendRedirect("students");
                break;

            case "search":
                String keyword = request.getParameter("keyword");
                List<Student> results = studentDAO.searchStudents(keyword);
                request.setAttribute("students", results);
                request.setAttribute("searchKeyword", keyword);
                request.getRequestDispatcher("/students.jsp").forward(request, response);
                break;

            case "resetpw":
                int resetId = Integer.parseInt(request.getParameter("id"));
                Student resetStudent = studentDAO.getStudentById(resetId);
                if (resetStudent != null && resetStudent.getUserId() != null) {
                    UserDAO pwDAO = new UserDAO();
                    pwDAO.updatePassword(resetStudent.getUserId(), "Student123!");
                    request.setAttribute("message", "Password reset for " + resetStudent.getFirstName() + " " + resetStudent.getLastName() + " (default: Student123!)");
                }
                List<Student> allStudents = studentDAO.getAllStudents();
                request.setAttribute("students", allStudents);
                request.getRequestDispatcher("/students.jsp").forward(request, response);
                break;

            default:
                List<Student> students = studentDAO.getAllStudents();
                request.setAttribute("students", students);
                request.getRequestDispatcher("/students.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        String firstName = request.getParameter("firstName").trim();
        String lastName = request.getParameter("lastName").trim();
        String email = request.getParameter("email").trim();
        String major = request.getParameter("major").trim();
        String gpaStr = request.getParameter("gpa");
        String enrollmentDateStr = request.getParameter("enrollmentDate");

        // Validation
        StringBuilder errors = new StringBuilder();

        if (firstName.isEmpty() || firstName.length() > 50) {
            errors.append("First name is required and must be under 50 characters. ");
        }
        if (lastName.isEmpty() || lastName.length() > 50) {
            errors.append("Last name is required and must be under 50 characters. ");
        }
        if (email.isEmpty() || !email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            errors.append("Valid email is required. ");
        }
        if (major.length() > 100) {
            errors.append("Major must be under 100 characters. ");
        }

        BigDecimal gpa;
        try {
            gpa = new BigDecimal(gpaStr);
            if (gpa.compareTo(BigDecimal.ZERO) < 0 || gpa.compareTo(new BigDecimal("4.00")) > 0) {
                errors.append("GPA must be between 0.00 and 4.00. ");
            }
        } catch (NumberFormatException e) {
            errors.append("Invalid GPA format. ");
            gpa = BigDecimal.ZERO;
        }

        LocalDate enrollmentDate;
        try {
            enrollmentDate = LocalDate.parse(enrollmentDateStr);
        } catch (Exception e) {
            errors.append("Invalid enrollment date. ");
            enrollmentDate = LocalDate.now();
        }

        // Sanitize inputs - prevent XSS
        firstName = sanitize(firstName);
        lastName = sanitize(lastName);
        email = sanitize(email);
        major = sanitize(major);

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString());
            request.setAttribute("students", studentDAO.getAllStudents());
            request.getRequestDispatcher("/students.jsp").forward(request, response);
            return;
        }

        if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Student student = new Student(firstName, lastName, email, major, gpa, enrollmentDate);
            student.setId(id);
            studentDAO.updateStudent(student);
        } else {
            UserDAO userDAO = new UserDAO();
            String studentId = userDAO.generateStudentId(firstName, lastName);
            String defaultPassword = "Student123!";

            int userId = userDAO.createUser(studentId, defaultPassword, "STUDENT");

            Student student = new Student(firstName, lastName, email, major, gpa, enrollmentDate);
            student.setUserId(userId);
            student.setStudentId(studentId);
            studentDAO.addStudent(student);
        }

        response.sendRedirect(request.getContextPath() + "/students");
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