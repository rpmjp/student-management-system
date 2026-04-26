<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>My Grades - Student Management System</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
  <script src="${pageContext.request.contextPath}/css/theme.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<nav>
  <a href="${pageContext.request.contextPath}/portal/home" class="nav-brand">SMS</a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/portal/home">Home</a>
    <a href="${pageContext.request.contextPath}/portal/grades" class="active">Grades</a>
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
  <h1>My Grades</h1>

  <div class="gpa-card">
    <div class="gpa-number">${calculatedGpa}</div>
    <div class="gpa-label">Cumulative GPA</div>
  </div>

  <div class="chart-card" style="margin-bottom: 20px;">
    <h3>Grade Breakdown</h3>
    <canvas id="gradeChart"></canvas>
  </div>

  <div class="card">
    <h2>All Courses</h2>
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

<script>
  var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
  var textColor = isDark ? '#e2e8f0' : '#1a2332';
  var grades = {};
  <c:forEach var="enrollment" items="${enrollments}">
  <c:if test="${not empty enrollment.grade}">
  var g = '${enrollment.grade}';
  var cat = g.startsWith('A') ? 'A' : g.startsWith('B') ? 'B' : g.startsWith('C') ? 'C' : g.startsWith('D') ? 'D' : 'F';
  grades[cat] = (grades[cat] || 0) + 1;
  </c:if>
  </c:forEach>
  new Chart(document.getElementById('gradeChart'), {
    type: 'bar',
    data: {
      labels: Object.keys(grades),
      datasets: [{ data: Object.values(grades), backgroundColor: ['#2dd4a8', '#2196F3', '#f5b731', '#FF9800', '#f44336'], borderRadius: 8 }]
    },
    options: {
      responsive: true, maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: { y: { beginAtZero: true, ticks: { stepSize: 1, color: textColor } }, x: { ticks: { color: textColor } } }
    }
  });
</script>
</body>
</html>