package com.robertjp.servlet;

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

    // Handles GET requests - shows the list of students
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Student> students = studentDAO.getAllStudents();
        request.setAttribute("students", students);
        request.getRequestDispatcher("/students.jsp").forward(request, response);
    }

    // Handles POST requests - adds a new student
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");
        BigDecimal gpa = new BigDecimal(request.getParameter("gpa"));
        LocalDate enrollmentDate = LocalDate.parse(request.getParameter("enrollmentDate"));

        Student student = new Student(firstName, lastName, email, major, gpa, enrollmentDate);
        studentDAO.addStudent(student);

        response.sendRedirect("students");
    }
}