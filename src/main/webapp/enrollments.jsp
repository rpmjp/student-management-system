<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Enrollments - Student Management System</title>
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
    <a href="${pageContext.request.contextPath}/courses">Courses</a>
    <a href="${pageContext.request.contextPath}/enrollments" class="active">Enrollments</a>
  </div>
  <div class="nav-user">
    <span class="nav-username">${sessionScope.displayName}</span>
    <button id="themeToggle" class="theme-toggle"></button>
    <a href="${pageContext.request.contextPath}/change-password" class="btn-settings">Settings</a>
    <a href="${pageContext.request.contextPath}/login?action=logout" class="btn-logout">Logout</a>
  </div>
</nav>

<div class="container">
  <h1>Enrollment & Grades</h1>

  <div class="card">
    <h2>Enroll Student in Course</h2>
    <form action="${pageContext.request.contextPath}/enrollments" method="post">
      <div class="form-grid" style="grid-template-columns: repeat(2, 1fr);">
        <select name="studentId" required>
          <option value="">-- Select Student --</option>
          <c:forEach var="student" items="${students}">
            <option value="${student.id}">${student.firstName} ${student.lastName}</option>
          </c:forEach>
        </select>
        <select name="courseId" required>
          <option value="">-- Select Course --</option>
          <c:forEach var="course" items="${courses}">
            <option value="${course.id}">${course.courseCode} - ${course.courseName}</option>
          </c:forEach>
        </select>
        <select name="semester" required>
          <option value="">-- Select Semester --</option>
          <option value="Fall 2025">Fall 2025</option>
          <option value="Spring 2026">Spring 2026</option>
          <option value="Summer 2026">Summer 2026</option>
          <option value="Fall 2026">Fall 2026</option>
          <option value="Spring 2027">Spring 2027</option>
        </select>
        <select name="grade">
          <option value="">-- Grade (optional) --</option>
          <option value="A">A</option><option value="A-">A-</option>
          <option value="B+">B+</option><option value="B">B</option><option value="B-">B-</option>
          <option value="C+">C+</option><option value="C">C</option><option value="C-">C-</option>
          <option value="D+">D+</option><option value="D">D</option>
          <option value="F">F</option>
        </select>
      </div>
      <button type="submit" class="btn btn-primary">Enroll Student</button>
    </form>
  </div>

  <h2 style="margin-bottom: 16px;">All Enrollments (${enrollments.size()})</h2>

  <div class="table-container">
    <table>
      <thead>
      <tr><th>Student</th><th>Course</th><th>Credits</th><th>Semester</th><th>Grade</th><th>Points</th><th>Actions</th></tr>
      </thead>
      <tbody>
      <c:forEach var="enrollment" items="${enrollments}">
        <tr>
          <td>${enrollment.studentName}</td>
          <td>${enrollment.courseCode} - ${enrollment.courseName}</td>
          <td>${enrollment.credits}</td>
          <td>${enrollment.semester}</td>
          <td>
            <c:choose>
              <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('A')}"><span class="grade-badge grade-a">${enrollment.grade}</span></c:when>
              <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('B')}"><span class="grade-badge grade-b">${enrollment.grade}</span></c:when>
              <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('C')}"><span class="grade-badge grade-c">${enrollment.grade}</span></c:when>
              <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('D')}"><span class="grade-badge grade-d">${enrollment.grade}</span></c:when>
              <c:when test="${enrollment.grade == 'F'}"><span class="grade-badge grade-f">${enrollment.grade}</span></c:when>
              <c:otherwise><span class="grade-badge no-grade">N/A</span></c:otherwise>
            </c:choose>
          </td>
          <td>${enrollment.gradePoints != null ? enrollment.gradePoints : '-'}</td>
          <td class="actions">
            <form action="${pageContext.request.contextPath}/enrollments" method="post" class="grade-form">
              <input type="hidden" name="action" value="grade">
              <input type="hidden" name="enrollmentId" value="${enrollment.id}">
              <select name="grade">
                <option value="A">A</option><option value="A-">A-</option>
                <option value="B+">B+</option><option value="B">B</option><option value="B-">B-</option>
                <option value="C+">C+</option><option value="C">C</option><option value="C-">C-</option>
                <option value="D+">D+</option><option value="D">D</option>
                <option value="F">F</option>
              </select>
              <button type="submit" class="btn btn-grade">Set</button>
            </form>
            <a href="${pageContext.request.contextPath}/enrollments?action=delete&id=${enrollment.id}" class="btn btn-delete" onclick="return confirm('Remove this enrollment?');">Drop</a>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty enrollments}">
        <tr><td colspan="7" style="text-align:center; padding: 30px;">No enrollments yet</td></tr>
      </c:if>
      </tbody>
    </table>
  </div>

  <div class="mobile-cards">
    <c:forEach var="enrollment" items="${enrollments}">
      <div class="mobile-card">
        <div class="mobile-card-header">
          <span class="mobile-card-name">${enrollment.studentName}</span>
          <c:choose>
            <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('A')}"><span class="grade-badge grade-a">${enrollment.grade}</span></c:when>
            <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('B')}"><span class="grade-badge grade-b">${enrollment.grade}</span></c:when>
            <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('C')}"><span class="grade-badge grade-c">${enrollment.grade}</span></c:when>
            <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('D')}"><span class="grade-badge grade-d">${enrollment.grade}</span></c:when>
            <c:when test="${enrollment.grade == 'F'}"><span class="grade-badge grade-f">${enrollment.grade}</span></c:when>
            <c:otherwise><span class="grade-badge no-grade">N/A</span></c:otherwise>
          </c:choose>
        </div>
        <div class="mobile-card-row"><span class="mobile-card-label">Course</span><span>${enrollment.courseCode}</span></div>
        <div class="mobile-card-row"><span class="mobile-card-label">Name</span><span>${enrollment.courseName}</span></div>
        <div class="mobile-card-row"><span class="mobile-card-label">Credits</span><span>${enrollment.credits}</span></div>
        <div class="mobile-card-row"><span class="mobile-card-label">Semester</span><span>${enrollment.semester}</span></div>
        <div class="mobile-card-row"><span class="mobile-card-label">Points</span><span>${enrollment.gradePoints != null ? enrollment.gradePoints : '-'}</span></div>
        <div class="mobile-card-actions">
          <form action="${pageContext.request.contextPath}/enrollments" method="post" class="mobile-grade-form">
            <input type="hidden" name="action" value="grade">
            <input type="hidden" name="enrollmentId" value="${enrollment.id}">
            <select name="grade">
              <option value="A">A</option><option value="A-">A-</option>
              <option value="B+">B+</option><option value="B">B</option><option value="B-">B-</option>
              <option value="C+">C+</option><option value="C">C</option><option value="C-">C-</option>
              <option value="D+">D+</option><option value="D">D</option>
              <option value="F">F</option>
            </select>
            <button type="submit" class="btn btn-grade">Set</button>
          </form>
          <a href="${pageContext.request.contextPath}/enrollments?action=delete&id=${enrollment.id}" class="btn btn-delete" onclick="return confirm('Remove?');">Drop</a>
        </div>
      </div>
    </c:forEach>
  </div>
</div>
</body>
</html>