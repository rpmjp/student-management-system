package com.robertjp.servlet;

import com.robertjp.util.MLClient;
import com.robertjp.dao.EnrollmentDAO;

import com.robertjp.dao.StudentDAO;
import com.robertjp.model.Student;

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

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");
        BigDecimal gpa = new BigDecimal(request.getParameter("gpa"));
        LocalDate enrollmentDate = LocalDate.parse(request.getParameter("enrollmentDate"));

        if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Student student = new Student(firstName, lastName, email, major, gpa, enrollmentDate);
            student.setId(id);
            studentDAO.updateStudent(student);
        } else {
            Student student = new Student(firstName, lastName, email, major, gpa, enrollmentDate);
            studentDAO.addStudent(student);
        }

        response.sendRedirect("students");
    }
}