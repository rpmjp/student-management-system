<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Courses - Student Management System</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
  <script src="${pageContext.request.contextPath}/css/theme.js"></script>
</head>
<body>
<nav>
  <a href="${pageContext.request.contextPath}/dashboard" class="nav-brand">SMS</a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
    <a href="${pageContext.request.contextPath}/students">Students</a>
    <a href="${pageContext.request.contextPath}/courses" class="active">Courses</a>
    <a href="${pageContext.request.contextPath}/enrollments">Enrollments</a>
  </div>
  <div class="nav-user">
    <span class="nav-username">${sessionScope.displayName}</span>
    <button id="themeToggle" class="theme-toggle"></button>
    <a href="${pageContext.request.contextPath}/change-password" class="btn-settings">Settings</a>
    <a href="${pageContext.request.contextPath}/login?action=logout" class="btn-logout">Logout</a>
  </div>
</nav>

<div class="container">
  <h1>Course Management</h1>

  <c:if test="${not empty error}">
    <div class="msg-error">${error}</div>
  </c:if>

  <div class="card">
    <h2>Add New Course</h2>
    <form action="${pageContext.request.contextPath}/courses" method="post">
      <div class="form-grid">
        <input type="text" name="courseCode" placeholder="Course Code (e.g. CS602)" required>
        <input type="text" name="courseName" placeholder="Course Name" required>
        <input type="number" name="credits" placeholder="Credits" min="1" max="6" required>
        <textarea name="description" placeholder="Course description (optional)" class="form-full"></textarea>
      </div>
      <button type="submit" class="btn btn-primary">Add Course</button>
    </form>
  </div>

  <h2 style="margin-bottom: 16px;">All Courses (${courses.size()})</h2>

  <div class="table-container">
    <table>
      <thead>
      <tr><th>Code</th><th>Name</th><th>Credits</th><th>Description</th><th>Actions</th></tr>
      </thead>
      <tbody>
      <c:forEach var="course" items="${courses}">
        <tr>
          <td>${course.courseCode}</td>
          <td>${course.courseName}</td>
          <td>${course.credits}</td>
          <td>${course.description}</td>
          <td><a href="${pageContext.request.contextPath}/courses?action=delete&id=${course.id}" class="btn btn-delete" onclick="return confirm('Delete this course?');">Delete</a></td>
        </tr>
      </c:forEach>
      <c:if test="${empty courses}">
        <tr><td colspan="5" style="text-align:center; padding: 30px;">No courses yet</td></tr>
      </c:if>
      </tbody>
    </table>
  </div>

  <div class="mobile-cards">
    <c:forEach var="course" items="${courses}">
      <div class="mobile-card">
        <div class="mobile-card-header">
          <span class="mobile-card-name">${course.courseCode}</span>
          <span class="mobile-card-badge">${course.credits} credits</span>
        </div>
        <div class="mobile-card-row"><span class="mobile-card-label">Name</span><span>${course.courseName}</span></div>
        <c:if test="${not empty course.description}">
          <div class="mobile-card-desc">${course.description}</div>
        </c:if>
        <div class="mobile-card-actions">
          <a href="${pageContext.request.contextPath}/courses?action=delete&id=${course.id}" class="btn btn-delete" onclick="return confirm('Delete this course?');">Delete</a>
        </div>
      </div>
    </c:forEach>
  </div>
</div>
</body>
</html>