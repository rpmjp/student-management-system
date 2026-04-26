<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Change Password - Student Management System</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
  <script src="${pageContext.request.contextPath}/css/theme.js"></script>
  <style>
    .pw-container { max-width: 500px; margin: 40px auto; }
    .form-group { margin-bottom: 20px; }
    .form-group label {
      display: block; font-size: 12px; font-weight: 600; color: var(--text-secondary);
      margin-bottom: 6px; text-transform: uppercase; letter-spacing: 1px;
    }
    .form-group input {
      width: 100%; padding: 12px; border: 1.5px solid var(--border); border-radius: 10px;
      font-size: 14px; background: var(--bg-card); color: var(--text-primary); transition: border 0.2s;
    }
    .form-group input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(45, 212, 168, 0.15); }
    .password-rules { font-size: 12px; color: var(--text-muted); margin-top: 8px; line-height: 1.6; }
    .btn-back { display: inline-block; margin-top: 16px; color: var(--primary); text-decoration: none; font-size: 14px; }
  </style>
</head>
<body>
<nav>
  <a href="${sessionScope.user.student ? pageContext.request.contextPath.concat('/portal/home') : pageContext.request.contextPath.concat('/dashboard')}" class="nav-brand">SMS</a>
  <div class="nav-links">
    <c:choose>
      <c:when test="${sessionScope.user.student}">
        <a href="${pageContext.request.contextPath}/portal/home">Home</a>
        <a href="${pageContext.request.contextPath}/portal/grades">Grades</a>
        <a href="${pageContext.request.contextPath}/portal/risk">Risk Check</a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/students">Students</a>
        <a href="${pageContext.request.contextPath}/courses">Courses</a>
        <a href="${pageContext.request.contextPath}/enrollments">Enrollments</a>
      </c:otherwise>
    </c:choose>
  </div>
  <div class="nav-user">
    <span class="nav-username">${sessionScope.displayName}</span>
    <button id="themeToggle" class="theme-toggle"></button>
    <a href="${pageContext.request.contextPath}/login?action=logout" class="btn-logout">Logout</a>
  </div>
</nav>

<div class="container pw-container">
  <div class="card">
    <h2>Change Password</h2>

    <c:if test="${not empty error}">
      <div class="msg-error">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="msg-success">${success}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/change-password" method="post">
      <div class="form-group">
        <label>Current Password</label>
        <input type="password" name="currentPassword" required>
      </div>
      <div class="form-group">
        <label>New Password</label>
        <input type="password" name="newPassword" required>
        <div class="password-rules">Must be at least 8 characters with uppercase, lowercase, number, and special character (!@#$%^&*)</div>
      </div>
      <div class="form-group">
        <label>Confirm New Password</label>
        <input type="password" name="confirmPassword" required>
      </div>
      <button type="submit" class="btn btn-primary" style="width: 100%;">Change Password</button>
    </form>

    <c:choose>
      <c:when test="${sessionScope.user.student}">
        <a href="${pageContext.request.contextPath}/portal/home" class="btn-back">Back to Portal</a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/dashboard" class="btn-back">Back to Dashboard</a>
      </c:otherwise>
    </c:choose>
  </div>
</div>
</body>
</html>