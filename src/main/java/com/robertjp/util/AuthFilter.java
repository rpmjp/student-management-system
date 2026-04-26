package com.robertjp.util;

import com.robertjp.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        // Public resources - no login required
        if (path.equals("") || path.equals("/") ||
                path.equals("/login") || path.equals("/login.jsp") ||
                path.startsWith("/api/") ||
                path.endsWith(".css") || path.endsWith(".js") ||
                path.endsWith(".png") || path.endsWith(".jpg") || path.endsWith(".ico")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Not logged in
        if (user == null) {
            if (path.endsWith(".jsp")) {
                chain.doFilter(request, response);
                return;
            }
            res.sendRedirect(contextPath + "/login");
            return;
        }

        // Student trying to access staff pages
        if (user.isStudent() && !path.startsWith("/portal") && !path.equals("/login") && !path.equals("/change-password") && !path.endsWith(".jsp")) {
            res.sendRedirect(contextPath + "/portal/home");
            return;
        }

        // Staff trying to access student portal
        if (!user.isStudent() && path.startsWith("/portal")) {
            res.sendRedirect(contextPath + "/dashboard");
            return;
        }

        chain.doFilter(request, response);
    }
}