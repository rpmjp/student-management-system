package com.robertjp.servlet;

import com.robertjp.dao.UserDAO;
import com.robertjp.dao.StudentDAO;
import com.robertjp.model.User;
import com.robertjp.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("login");
            return;
        }

        // If already logged in, redirect to appropriate page
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.isStudent()) {
                response.sendRedirect(request.getContextPath() + "/portal/home");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }
            return;
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username").trim().toLowerCase();
        String password = request.getParameter("password");

        User user = userDAO.authenticate(username, password);

        if (user == null) {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (!user.isActive()) {
            request.setAttribute("error", "Account is disabled. Contact administrator.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Create session
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        // Set display name
        if (user.isStudent()) {
            // display name set below after finding student record
        } else {
            // Get staff name from database
            try (java.sql.Connection conn = com.robertjp.util.DBConnection.getConnection();
                 java.sql.PreparedStatement stmt = conn.prepareStatement("SELECT first_name, last_name FROM staff WHERE user_id = ?")) {
                stmt.setInt(1, user.getId());
                java.sql.ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    session.setAttribute("displayName", rs.getString("first_name") + " " + rs.getString("last_name"));
                } else {
                    session.setAttribute("displayName", user.getUsername());
                }
            } catch (Exception e) {
                session.setAttribute("displayName", user.getUsername());
            }
        }
        session.setMaxInactiveInterval(30 * 60); // 30 minutes

        // If student, find their student record
        if (user.isStudent()) {
            StudentDAO studentDAO = new StudentDAO();
            List<Student> allStudents = studentDAO.getAllStudents();
            for (Student s : allStudents) {
                if (s.getUserId() != null && s.getUserId().equals(user.getId())) {
                    session.setAttribute("studentRecord", s);
                    session.setAttribute("displayName", s.getFirstName() + " " + s.getLastName());
                    break;
                }
            }
            response.sendRedirect(request.getContextPath() + "/portal/home");
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
}