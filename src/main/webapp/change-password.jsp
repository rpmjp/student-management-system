<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Change Password - Student Management System</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', Arial, sans-serif; background: #f0f2f5; color: #333; }

    nav { background: #1a1a2e; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; }
    .nav-brand { color: #e94560; font-size: 20px; font-weight: bold; text-decoration: none; }
    .nav-links { display: flex; gap: 5px; flex-wrap: wrap; }
    .nav-links a { color: #ccc; text-decoration: none; padding: 8px 16px; border-radius: 6px; font-size: 14px; transition: all 0.2s; }
    .nav-links a:hover, .nav-links a.active { background: #16213e; color: #e94560; }
    .nav-user { display: flex; align-items: center; gap: 12px; }
    .nav-username { color: #e94560; font-weight: 600; font-size: 14px; }
    .btn-logout { color: #ccc; text-decoration: none; padding: 6px 14px; border: 1px solid #444; border-radius: 6px; font-size: 13px; transition: all 0.2s; }
    .btn-logout:hover { background: #e94560; color: white; border-color: #e94560; }

    .container { max-width: 500px; margin: 40px auto; padding: 20px; }
    .card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    .card h2 { font-size: 22px; margin-bottom: 24px; color: #1a1a2e; }

    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; font-size: 13px; font-weight: 600; color: #555; margin-bottom: 6px; text-transform: uppercase; letter-spacing: 0.5px; }
    .form-group input { width: 100%; padding: 12px; border: 2px solid #e0e0e0; border-radius: 8px; font-size: 14px; transition: border 0.2s; }
    .form-group input:focus { outline: none; border-color: #e94560; }

    .btn-primary { width: 100%; padding: 12px; background: #e94560; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: background 0.2s; }
    .btn-primary:hover { background: #c81e45; }

    .btn-back { display: inline-block; margin-top: 16px; color: #e94560; text-decoration: none; font-size: 14px; }

    .error-message { background: #FFEBEE; color: #C62828; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; }
    .success-message { background: #E8F5E9; color: #2E7D32; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; }

    .password-rules { font-size: 12px; color: #888; margin-top: 8px; line-height: 1.6; }

    @media (max-width: 600px) {
      nav { padding: 12px 16px; }
      .nav-brand { font-size: 18px; width: 100%; margin-bottom: 8px; }
      .nav-links { width: 100%; }
      .nav-links a { padding: 6px 12px; font-size: 13px; }
      .nav-user { width: 100%; justify-content: space-between; margin-top: 8px; }
      .container { padding: 12px; margin-top: 20px; }
      .card { padding: 20px; }

      .btn-settings { color: #ccc; text-decoration: none; padding: 6px 14px; border-radius: 6px; font-size: 13px; transition: all 0.2s; }
      .btn-settings:hover { background: #16213e; color: #e94560; }
    }
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
    <a href="${pageContext.request.contextPath}/login?action=logout" class="btn-logout">Logout</a>
  </div>
</nav>

<div class="container">
  <div class="card">
    <h2>Change Password</h2>

    <c:if test="${not empty error}">
      <div class="error-message">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="success-message">${success}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/change-password" method="post">
      <div class="form-group">
        <label>Current Password</label>
        <input type="password" name="currentPassword" required>
      </div>
      <div class="form-group">
        <label>New Password</label>
        <input type="password" name="newPassword" required>
        <div class="password-rules">
          Must be at least 8 characters with uppercase, lowercase, number, and special character (!@#$%^&*)
        </div>
      </div>
      <div class="form-group">
        <label>Confirm New Password</label>
        <input type="password" name="confirmPassword" required>
      </div>
      <button type="submit" class="btn-primary">Change Password</button>
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