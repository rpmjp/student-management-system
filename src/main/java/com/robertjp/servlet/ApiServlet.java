package com.robertjp.servlet;

import com.robertjp.dao.CourseDAO;
import com.robertjp.dao.EnrollmentDAO;
import com.robertjp.dao.StudentDAO;
import com.robertjp.model.Course;
import com.robertjp.model.Enrollment;
import com.robertjp.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/api/*")
public class ApiServlet extends HttpServlet {

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

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String path = request.getPathInfo();
        if (path == null) path = "/";

        switch (path) {
            case "/students":
                out.print(studentsToJson(studentDAO.getAllStudents()));
                break;

            case "/courses":
                out.print(coursesToJson(courseDAO.getAllCourses()));
                break;

            case "/enrollments":
                out.print(enrollmentsToJson(enrollmentDAO.getAllEnrollments()));
                break;

            case "/stats":
                out.print(statsToJson());
                break;

            default:
                response.setStatus(404);
                out.print("{\"error\": \"Endpoint not found. Available: /api/students, /api/courses, /api/enrollments, /api/stats\"}");
                break;
        }
        out.flush();
    }

    private String studentsToJson(List<Student> students) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < students.size(); i++) {
            Student s = students.get(i);
            BigDecimal gpa = enrollmentDAO.calculateGPA(s.getId());
            json.append("{")
                    .append("\"id\":").append(s.getId()).append(",")
                    .append("\"firstName\":\"").append(s.getFirstName()).append("\",")
                    .append("\"lastName\":\"").append(s.getLastName()).append("\",")
                    .append("\"email\":\"").append(s.getEmail()).append("\",")
                    .append("\"major\":\"").append(s.getMajor() != null ? s.getMajor() : "").append("\",")
                    .append("\"gpa\":").append(gpa)
                    .append("}");
            if (i < students.size() - 1) json.append(",");
        }
        json.append("]");
        return json.toString();
    }

    private String coursesToJson(List<Course> courses) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < courses.size(); i++) {
            Course c = courses.get(i);
            json.append("{")
                    .append("\"id\":").append(c.getId()).append(",")
                    .append("\"courseCode\":\"").append(c.getCourseCode()).append("\",")
                    .append("\"courseName\":\"").append(c.getCourseName()).append("\",")
                    .append("\"credits\":").append(c.getCredits())
                    .append("}");
            if (i < courses.size() - 1) json.append(",");
        }
        json.append("]");
        return json.toString();
    }

    private String enrollmentsToJson(List<Enrollment> enrollments) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < enrollments.size(); i++) {
            Enrollment e = enrollments.get(i);
            json.append("{")
                    .append("\"id\":").append(e.getId()).append(",")
                    .append("\"studentName\":\"").append(e.getStudentName()).append("\",")
                    .append("\"courseCode\":\"").append(e.getCourseCode()).append("\",")
                    .append("\"courseName\":\"").append(e.getCourseName()).append("\",")
                    .append("\"semester\":\"").append(e.getSemester()).append("\",")
                    .append("\"grade\":\"").append(e.getGrade() != null ? e.getGrade() : "").append("\",")
                    .append("\"gradePoints\":").append(e.getGradePoints() != null ? e.getGradePoints() : "null")
                    .append("}");
            if (i < enrollments.size() - 1) json.append(",");
        }
        json.append("]");
        return json.toString();
    }

    private String statsToJson() {
        List<Student> students = studentDAO.getAllStudents();
        List<Enrollment> enrollments = enrollmentDAO.getAllEnrollments();

        int graded = 0;
        for (Enrollment e : enrollments) {
            if (e.getGrade() != null && !e.getGrade().isEmpty()) graded++;
        }

        return "{" +
                "\"totalStudents\":" + students.size() + "," +
                "\"totalCourses\":" + courseDAO.getAllCourses().size() + "," +
                "\"totalEnrollments\":" + enrollments.size() + "," +
                "\"gradedEnrollments\":" + graded + "," +
                "\"ungradedEnrollments\":" + (enrollments.size() - graded) +
                "}";
    }
}