<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Courses - Student Management System</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', Arial, sans-serif; background: #f0f2f5; color: #333; }

    nav { background: #1a1a2e; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; }
    .nav-brand { color: #e94560; font-size: 20px; font-weight: bold; text-decoration: none; }
    .nav-links { display: flex; gap: 5px; flex-wrap: wrap; }
    .nav-links a { color: #ccc; text-decoration: none; padding: 8px 16px; border-radius: 6px; font-size: 14px; transition: all 0.2s; }
    .nav-links a:hover, .nav-links a.active { background: #16213e; color: #e94560; }

    .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
    h1 { font-size: 28px; margin-bottom: 20px; color: #1a1a2e; }

    .card { background: white; padding: 24px; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    .card h2 { font-size: 20px; margin-bottom: 16px; color: #1a1a2e; }

    .form-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin-bottom: 12px; }
    .form-grid input, .form-grid textarea { padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; width: 100%; transition: border 0.2s; font-family: inherit; }
    .form-grid input:focus, .form-grid textarea:focus { outline: none; border-color: #e94560; }
    .form-full { grid-column: 1 / -1; }
    textarea { min-height: 70px; resize: vertical; }

    .btn { padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-block; transition: all 0.2s; font-weight: 500; }
    .btn-primary { background: #e94560; color: white; }
    .btn-primary:hover { background: #c81e45; }
    .btn-delete { background: #f44336; color: white; padding: 6px 14px; font-size: 13px; }
    .btn-delete:hover { background: #d32f2f; }

    .table-container { overflow-x: auto; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    table { width: 100%; background: white; border-collapse: collapse; }
    th { background: #1a1a2e; color: white; padding: 14px 12px; text-align: left; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; }
    td { padding: 14px 12px; border-bottom: 1px solid #eee; font-size: 14px; }
    tr:hover { background: #f8f9fa; }

    .mobile-cards { display: none; }
    .mobile-card { background: white; border-radius: 12px; padding: 16px; margin-bottom: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    .mobile-card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
    .mobile-card-name { font-weight: bold; font-size: 16px; color: #1a1a2e; }
    .mobile-card-badge { background: #e94560; color: white; padding: 3px 10px; border-radius: 12px; font-size: 12px; }
    .mobile-card-row { display: flex; justify-content: space-between; padding: 6px 0; border-bottom: 1px solid #f0f0f0; font-size: 14px; }
    .mobile-card-label { color: #666; }
    .mobile-card-desc { padding: 8px 0; font-size: 14px; color: #555; }
    .mobile-card-actions { margin-top: 12px; }

    @media (max-width: 900px) {
      .form-grid { grid-template-columns: repeat(2, 1fr); }
    }

    @media (max-width: 600px) {
      nav { padding: 12px 16px; }
      .nav-brand { font-size: 18px; width: 100%; margin-bottom: 8px; }
      .nav-links { width: 100%; }
      .nav-links a { padding: 6px 12px; font-size: 13px; }
      .nav-user { width: 100%; justify-content: space-between; margin-top: 8px; }
      .container { padding: 12px; }
      h1 { font-size: 22px; }
      .card { padding: 16px; }
      .card h2 { font-size: 18px; }
      .form-grid { grid-template-columns: 1fr; }
      .table-container { display: none; }
      .mobile-cards { display: block; }
    }
    .nav-user { display: flex; align-items: center; gap: 12px; }
    .nav-username { color: #e94560; font-weight: 600; font-size: 14px; }
    .btn-logout { color: #ccc; text-decoration: none; padding: 6px 14px; border: 1px solid #444; border-radius: 6px; font-size: 13px; transition: all 0.2s; }
    .btn-logout:hover { background: #e94560; color: white; border-color: #e94560; }

    .btn-settings { color: #ccc; text-decoration: none; padding: 6px 14px; border-radius: 6px; font-size: 13px; transition: all 0.2s; }
    .btn-settings:hover { background: #16213e; color: #e94560; }
  </style>
</head>
<body>
<nav>
  <a href="dashboard" class="nav-brand">SMS</a>
  <div class="nav-links">
    <a href="dashboard" class="${pageContext.request.servletPath == '/dashboard.jsp' ? 'active' : ''}">Dashboard</a>
    <a href="students" class="${pageContext.request.servletPath == '/students.jsp' ? 'active' : ''}">Students</a>
    <a href="courses" class="${pageContext.request.servletPath == '/courses.jsp' ? 'active' : ''}">Courses</a>
    <a href="enrollments" class="${pageContext.request.servletPath == '/enrollments.jsp' ? 'active' : ''}">Enrollments</a>
  </div>
  <div class="nav-user">
    <span class="nav-username">${sessionScope.displayName}</span>
    <a href="${pageContext.request.contextPath}/change-password" class="btn-settings">Settings</a>
    <a href="${pageContext.request.contextPath}/login?action=logout" class="btn-logout">Logout</a>
  </div>
</nav>

<div class="container">
  <h1>Course Management</h1>

  <c:if test="${not empty error}">
    <div class="card" style="border-left: 5px solid #f44336; margin-bottom: 20px;">
      <p style="color: #C62828; font-weight: 500;">${error}</p>
    </div>
  </c:if>

  <div class="card">
    <h2>Add New Course</h2>
    <form action="courses" method="post">
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

  <!-- Desktop Table -->
  <div class="table-container">
    <table>
      <thead>
      <tr>
        <th>Code</th>
        <th>Name</th>
        <th>Credits</th>
        <th>Description</th>
        <th>Actions</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="course" items="${courses}">
        <tr>
          <td>${course.courseCode}</td>
          <td>${course.courseName}</td>
          <td>${course.credits}</td>
          <td>${course.description}</td>
          <td>
            <a href="courses?action=delete&id=${course.id}" class="btn btn-delete"
               onclick="return confirm('Delete this course?');">Delete</a>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty courses}">
        <tr><td colspan="5" style="text-align:center; padding: 30px;">No courses yet — add one above!</td></tr>
      </c:if>
      </tbody>
    </table>
  </div>

  <!-- Mobile Cards -->
  <div class="mobile-cards">
    <c:forEach var="course" items="${courses}">
      <div class="mobile-card">
        <div class="mobile-card-header">
          <span class="mobile-card-name">${course.courseCode}</span>
          <span class="mobile-card-badge">${course.credits} credits</span>
        </div>
        <div class="mobile-card-row">
          <span class="mobile-card-label">Name</span>
          <span>${course.courseName}</span>
        </div>
        <c:if test="${not empty course.description}">
          <div class="mobile-card-desc">${course.description}</div>
        </c:if>
        <div class="mobile-card-actions">
          <a href="courses?action=delete&id=${course.id}" class="btn btn-delete"
             onclick="return confirm('Delete this course?');">Delete</a>
        </div>
      </div>
    </c:forEach>
    <c:if test="${empty courses}">
      <div class="card" style="text-align:center; padding: 30px;">No courses yet — add one above!</div>
    </c:if>
  </div>
</div>
</body>
</html>