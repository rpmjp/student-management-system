<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Dashboard - Student Management System</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', Arial, sans-serif; background: #f0f2f5; color: #333; }

    /* Navigation */
    nav { background: #1a1a2e; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; }
    .nav-brand { color: #e94560; font-size: 20px; font-weight: bold; text-decoration: none; }
    .nav-links { display: flex; gap: 5px; flex-wrap: wrap; }
    .nav-links a { color: #ccc; text-decoration: none; padding: 8px 16px; border-radius: 6px; font-size: 14px; transition: all 0.2s; }
    .nav-links a:hover, .nav-links a.active { background: #16213e; color: #e94560; }

    /* Main Content */
    .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
    h1 { font-size: 28px; margin-bottom: 20px; color: #1a1a2e; }

    /* Stats Grid */
    .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 24px; }
    .stat-card { background: white; padding: 24px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); text-align: center; }
    .stat-number { font-size: 40px; font-weight: bold; margin: 8px 0; }
    .stat-label { color: #666; font-size: 13px; text-transform: uppercase; letter-spacing: 1px; }
    .stat-students .stat-number { color: #4CAF50; }
    .stat-courses .stat-number { color: #2196F3; }
    .stat-enrollments .stat-number { color: #FF9800; }
    .stat-gpa .stat-number { color: #9C27B0; }

    /* Charts Grid */
    .charts-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
    .chart-card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    .chart-card h3 { margin-bottom: 16px; color: #1a1a2e; font-size: 16px; }
    canvas { max-height: 280px; width: 100% !important; }

    /* Responsive */
    @media (max-width: 900px) {
      .stats-grid { grid-template-columns: repeat(2, 1fr); }
      .charts-grid { grid-template-columns: repeat(2, 1fr); }
    }

    @media (max-width: 600px) {
      nav { padding: 12px 16px; }
      .nav-brand { font-size: 18px; width: 100%; margin-bottom: 8px; }
      .nav-links { width: 100%; }
      .nav-links a { padding: 6px 12px; font-size: 13px; }
      .container { padding: 12px; }
      h1 { font-size: 22px; }
      .stats-grid { grid-template-columns: repeat(2, 1fr); gap: 10px; }
      .stat-card { padding: 16px; }
      .stat-number { font-size: 30px; }
      .stat-label { font-size: 11px; }
      .charts-grid { grid-template-columns: 1fr; }
      .chart-card { padding: 16px; }
      .chart-card h3 { font-size: 15px; }
    }
  </style>
</head>
<body>
<nav>
  <a href="dashboard" class="nav-brand">SMS</a>
  <div class="nav-links">
    <a href="dashboard" class="active">Dashboard</a>
    <a href="students">Students</a>
    <a href="courses">Courses</a>
    <a href="enrollments">Enrollments</a>
  </div>
</nav>

<div class="container">
  <h1>Dashboard</h1>

  <!-- Stats Cards -->
  <div class="stats-grid">
    <div class="stat-card stat-students">
      <div class="stat-label">Total Students</div>
      <div class="stat-number">${totalStudents}</div>
    </div>
    <div class="stat-card stat-courses">
      <div class="stat-label">Total Courses</div>
      <div class="stat-number">${totalCourses}</div>
    </div>
    <div class="stat-card stat-enrollments">
      <div class="stat-label">Enrollments</div>
      <div class="stat-number">${totalEnrollments}</div>
    </div>
    <div class="stat-card stat-gpa">
      <div class="stat-label">Average GPA</div>
      <div class="stat-number">${avgGpa}</div>
    </div>
  </div>

  <!-- Charts -->
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
  Chart.defaults.font.family = "'Segoe UI', Arial, sans-serif";
  Chart.defaults.plugins.legend.labels.usePointStyle = true;

  new Chart(document.getElementById('gradeChart'), {
    type: 'bar',
    data: {
      labels: ['A Range', 'B Range', 'C Range', 'D Range', 'F'],
      datasets: [{
        label: 'Number of Grades',
        data: [${gpaA}, ${gpaB}, ${gpaC}, ${gpaD}, ${gpaF}],
        backgroundColor: ['#4CAF50', '#2196F3', '#FF9800', '#FFC107', '#f44336'],
        borderRadius: 6
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
    }
  });

  new Chart(document.getElementById('gradedChart'), {
    type: 'doughnut',
    data: {
      labels: ['Graded', 'Ungraded'],
      datasets: [{
        data: [${graded}, ${ungraded}],
        backgroundColor: ['#4CAF50', '#E0E0E0'],
        borderWidth: 0
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      cutout: '65%'
    }
  });

  new Chart(document.getElementById('courseChart'), {
    type: 'bar',
    data: {
      labels: [<c:forEach var="entry" items="${courseEnrollments}" varStatus="status">'${entry.key}'<c:if test="${!status.last}">,</c:if></c:forEach>],
      datasets: [{
        label: 'Students Enrolled',
        data: [<c:forEach var="entry" items="${courseEnrollments}" varStatus="status">${entry.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
        backgroundColor: '#2196F3',
        borderRadius: 6
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
    }
  });

  new Chart(document.getElementById('majorChart'), {
    type: 'pie',
    data: {
      labels: [<c:forEach var="entry" items="${majorDistribution}" varStatus="status">'${entry.key}'<c:if test="${!status.last}">,</c:if></c:forEach>],
      datasets: [{
        data: [<c:forEach var="entry" items="${majorDistribution}" varStatus="status">${entry.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
        backgroundColor: ['#4CAF50', '#2196F3', '#FF9800', '#9C27B0', '#f44336', '#00BCD4', '#E91E63', '#795548'],
        borderWidth: 0
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false
    }
  });
</script>
</body>
</html>