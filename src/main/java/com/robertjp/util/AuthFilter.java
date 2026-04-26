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

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        System.out.println("FILTER: path=" + path + " user=" + (user != null ? user.getUsername() + "(" + user.getRole() + ")" : "null"));

        // Always allow these through
        if (path.equals("") || path.equals("/") ||
                path.equals("/login") || path.equals("/login.jsp") ||
                path.startsWith("/api/") ||
                path.endsWith(".css") || path.endsWith(".js") ||
                path.endsWith(".png") || path.endsWith(".jpg") || path.endsWith(".ico")) {
            System.out.println("FILTER: ALLOWED (public resource)");
            chain.doFilter(request, response);
            return;
        }

        // Not logged in
        if (user == null) {
            if (path.endsWith(".jsp")) {
                System.out.println("FILTER: ALLOWED (jsp forward, no user)");
                chain.doFilter(request, response);
                return;
            }
            System.out.println("FILTER: REDIRECT to login (no user)");
            res.sendRedirect(contextPath + "/login");
            return;
        }

        // Student trying to access staff pages
        if (user.isStudent() && !path.startsWith("/portal") && !path.equals("/login") && !path.equals("/change-password") && !path.endsWith(".jsp")) {
            System.out.println("FILTER: REDIRECT student to portal (accessing staff page: " + path + ")");
            res.sendRedirect(contextPath + "/portal/home");
            return;
        }

        // Staff trying to access student portal
        if (!user.isStudent() && path.startsWith("/portal")) {
            System.out.println("FILTER: REDIRECT staff to dashboard (accessing portal)");
            res.sendRedirect(contextPath + "/dashboard");
            return;
        }

        System.out.println("FILTER: ALLOWED (passed all checks)");
        chain.doFilter(request, response);
    }
}