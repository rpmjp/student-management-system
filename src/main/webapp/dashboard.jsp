<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Dashboard - Student Management System</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
  <script src="${pageContext.request.contextPath}/css/theme.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<nav>
  <a href="${pageContext.request.contextPath}/dashboard" class="nav-brand">SMS</a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/dashboard" class="active">Dashboard</a>
    <a href="${pageContext.request.contextPath}/students">Students</a>
    <a href="${pageContext.request.contextPath}/courses">Courses</a>
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
  <h1>Dashboard</h1>

  <div class="stats-grid">
    <div class="stat-card">
      <div class="stat-label">Total Students</div>
      <div class="stat-number" style="color: var(--primary)">${totalStudents}</div>
    </div>
    <div class="stat-card">
      <div class="stat-label">Total Courses</div>
      <div class="stat-number" style="color: var(--gold)">${totalCourses}</div>
    </div>
    <div class="stat-card">
      <div class="stat-label">Enrollments</div>
      <div class="stat-number" style="color: var(--info)">${totalEnrollments}</div>
    </div>
    <div class="stat-card">
      <div class="stat-label">Average GPA</div>
      <div class="stat-number" style="color: var(--purple)">${avgGpa}</div>
    </div>
  </div>

  <div class="charts-grid">
    <div class="chart-card">
      <h3>Grade Distribution</h3>
      <canvas id="gradeChart"></canvas>
    </div>
    <div class="chart-card">
      <h3>Graded vs Ungraded</h3>
      <canvas id="gradedChart"></canvas>
    </div>
    <div class="chart-card">
      <h3>Enrollments per Course</h3>
      <canvas id="courseChart"></canvas>
    </div>
    <div class="chart-card">
      <h3>Students by Major</h3>
      <canvas id="majorChart"></canvas>
    </div>
  </div>
</div>

<script>
  var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
  var textColor = isDark ? '#e2e8f0' : '#1a2332';
  var gridColor = isDark ? '#1e2a36' : '#e2e8f0';

  Chart.defaults.font.family = "'Segoe UI', sans-serif";
  Chart.defaults.color = textColor;
  Chart.defaults.plugins.legend.labels.usePointStyle = true;
  Chart.defaults.scale = Chart.defaults.scale || {};

  new Chart(document.getElementById('gradeChart'), {
    type: 'bar',
    data: {
      labels: ['A Range', 'B Range', 'C Range', 'D Range', 'F'],
      datasets: [{
        label: 'Grades',
        data: [${gpaA}, ${gpaB}, ${gpaC}, ${gpaD}, ${gpaF}],
        backgroundColor: ['#2dd4a8', '#2196F3', '#f5b731', '#FF9800', '#f44336'],
        borderRadius: 8
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: {
        y: { beginAtZero: true, ticks: { stepSize: 1, color: textColor }, grid: { color: gridColor } },
        x: { ticks: { color: textColor }, grid: { display: false } }
      }
    }
  });

  new Chart(document.getElementById('gradedChart'), {
    type: 'doughnut',
    data: {
      labels: ['Graded', 'Ungraded'],
      datasets: [{
        data: [${graded}, ${ungraded}],
        backgroundColor: ['#2dd4a8', isDark ? '#2a3a4a' : '#E0E0E0'],
        borderWidth: 0
      }]
    },
    options: { responsive: true, maintainAspectRatio: false, cutout: '65%' }
  });

  new Chart(document.getElementById('courseChart'), {
    type: 'bar',
    data: {
      labels: [<c:forEach var="entry" items="${courseEnrollments}" varStatus="status">'${entry.key}'<c:if test="${!status.last}">,</c:if></c:forEach>],
      datasets: [{
        label: 'Students',
        data: [<c:forEach var="entry" items="${courseEnrollments}" varStatus="status">${entry.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
        backgroundColor: '#2196F3',
        borderRadius: 8
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: {
        y: { beginAtZero: true, ticks: { stepSize: 1, color: textColor }, grid: { color: gridColor } },
        x: { ticks: { color: textColor }, grid: { display: false } }
      }
    }
  });

  new Chart(document.getElementById('majorChart'), {
    type: 'pie',
    data: {
      labels: [<c:forEach var="entry" items="${majorDistribution}" varStatus="status">'${entry.key}'<c:if test="${!status.last}">,</c:if></c:forEach>],
      datasets: [{
        data: [<c:forEach var="entry" items="${majorDistribution}" varStatus="status">${entry.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
        backgroundColor: ['#2dd4a8', '#2196F3', '#f5b731', '#9C27B0', '#f44336', '#00BCD4', '#FF9800', '#795548'],
        borderWidth: 0
      }]
    },
    options: { responsive: true, maintainAspectRatio: false }
  });
</script>
</body>
</html>