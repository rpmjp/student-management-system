package com.robertjp.servlet;

import com.robertjp.dao.UserDAO;
import com.robertjp.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/change-password")
public class PasswordServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Verify current password
        User verified = userDAO.authenticate(user.getUsername(), currentPassword);
        if (verified == null) {
            request.setAttribute("error", "Current password is incorrect.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        // Check new passwords match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New passwords do not match.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        // Check password strength
        if (newPassword.length() < 8 || !newPassword.matches(".*[A-Z].*") ||
                !newPassword.matches(".*[a-z].*") || !newPassword.matches(".*[0-9].*") ||
                !newPassword.matches(".*[!@#$%^&*].*")) {
            request.setAttribute("error", "Password must be at least 8 characters with uppercase, lowercase, number, and special character.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        // Update password
        boolean updated = userDAO.updatePassword(user.getId(), newPassword);
        if (updated) {
            request.setAttribute("success", "Password changed successfully!");
        } else {
            request.setAttribute("error", "Failed to update password. Please try again.");
        }

        request.getRequestDispatcher("/change-password.jsp").forward(request, response);
    }
}