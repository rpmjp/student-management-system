package com.robertjp.servlet;

import com.robertjp.dao.UserDAO;
import com.robertjp.dao.StudentDAO;
import com.robertjp.model.User;
import com.robertjp.model.Student;
import com.robertjp.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

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

        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setMaxInactiveInterval(30 * 60);

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
            if (session.getAttribute("displayName") == null) {
                session.setAttribute("displayName", username);
            }
            response.sendRedirect(request.getContextPath() + "/portal/home");
        } else {
            String displayName = getStaffName(user.getId());
            session.setAttribute("displayName", displayName != null ? displayName : username);
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }

    private String getStaffName(int userId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "SELECT first_name, last_name FROM staff WHERE user_id = ?")) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("first_name") + " " + rs.getString("last_name");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}