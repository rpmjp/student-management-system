<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>My Portal - Student Management System</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
  <script src="${pageContext.request.contextPath}/css/theme.js"></script>
</head>
<body>
<nav>
  <a href="${pageContext.request.contextPath}/portal/home" class="nav-brand">SMS</a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/portal/home" class="active">Home</a>
    <a href="${pageContext.request.contextPath}/portal/grades">Grades</a>
    <a href="${pageContext.request.contextPath}/portal/risk">Risk Check</a>
  </div>
  <div class="nav-user">
    <span class="nav-username">${sessionScope.displayName}</span>
    <button id="themeToggle" class="theme-toggle"></button>
    <a href="${pageContext.request.contextPath}/change-password" class="btn-settings">Settings</a>
    <a href="${pageContext.request.contextPath}/login?action=logout" class="btn-logout">Logout</a>
  </div>
</nav>

<div class="container">
  <div class="welcome-card">
    <div class="welcome-name">Welcome, ${sessionScope.studentRecord.firstName}!</div>
    <div class="welcome-id">Student ID: ${sessionScope.studentRecord.studentId}</div>
    <div class="welcome-major">${sessionScope.studentRecord.major}</div>
  </div>

  <div class="stats-grid" style="grid-template-columns: repeat(3, 1fr);">
    <div class="stat-card">
      <div class="stat-label">Current GPA</div>
      <div class="stat-number" style="color: var(--primary)">${calculatedGpa}</div>
    </div>
    <div class="stat-card">
      <div class="stat-label">Courses</div>
      <div class="stat-number" style="color: var(--info)">${totalCourses}</div>
    </div>
    <div class="stat-card">
      <div class="stat-label">Credits</div>
      <div class="stat-number" style="color: var(--gold)">${totalCredits}</div>
    </div>
  </div>

  <div class="card">
    <h2>Current Enrollments</h2>
    <div class="table-container" style="box-shadow: none; border: none;">
      <table>
        <thead>
        <tr><th>Course</th><th>Name</th><th>Credits</th><th>Semester</th><th>Grade</th><th>Points</th></tr>
        </thead>
        <tbody>
        <c:forEach var="enrollment" items="${enrollments}">
          <tr>
            <td>${enrollment.courseCode}</td>
            <td>${enrollment.courseName}</td>
            <td>${enrollment.credits}</td>
            <td>${enrollment.semester}</td>
            <td>
              <c:choose>
                <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('A')}"><span class="grade-badge grade-a">${enrollment.grade}</span></c:when>
                <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('B')}"><span class="grade-badge grade-b">${enrollment.grade}</span></c:when>
                <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('C')}"><span class="grade-badge grade-c">${enrollment.grade}</span></c:when>
                <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('D')}"><span class="grade-badge grade-d">${enrollment.grade}</span></c:when>
                <c:when test="${enrollment.grade == 'F'}"><span class="grade-badge grade-f">${enrollment.grade}</span></c:when>
                <c:otherwise><span class="grade-badge no-grade">Pending</span></c:otherwise>
              </c:choose>
            </td>
            <td>${enrollment.gradePoints != null ? enrollment.gradePoints : '-'}</td>
          </tr>
        </c:forEach>
        <c:if test="${empty enrollments}">
          <tr><td colspan="6" style="text-align:center; padding: 30px;">No enrollments yet</td></tr>
        </c:if>
        </tbody>
      </table>
    </div>

    <div class="mobile-cards">
      <c:forEach var="enrollment" items="${enrollments}">
        <div class="mobile-card">
          <div class="mobile-card-header">
            <span class="mobile-card-name">${enrollment.courseCode}</span>
            <c:choose>
              <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('A')}"><span class="grade-badge grade-a">${enrollment.grade}</span></c:when>
              <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('B')}"><span class="grade-badge grade-b">${enrollment.grade}</span></c:when>
              <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('C')}"><span class="grade-badge grade-c">${enrollment.grade}</span></c:when>
              <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('D')}"><span class="grade-badge grade-d">${enrollment.grade}</span></c:when>
              <c:when test="${enrollment.grade == 'F'}"><span class="grade-badge grade-f">${enrollment.grade}</span></c:when>
              <c:otherwise><span class="grade-badge no-grade">Pending</span></c:otherwise>
            </c:choose>
          </div>
          <div class="mobile-card-row"><span class="mobile-card-label">Course</span><span>${enrollment.courseName}</span></div>
          <div class="mobile-card-row"><span class="mobile-card-label">Credits</span><span>${enrollment.credits}</span></div>
          <div class="mobile-card-row"><span class="mobile-card-label">Semester</span><span>${enrollment.semester}</span></div>
          <div class="mobile-card-row"><span class="mobile-card-label">Points</span><span>${enrollment.gradePoints != null ? enrollment.gradePoints : '-'}</span></div>
        </div>
      </c:forEach>
    </div>
  </div>
</div>
</body>
</html>