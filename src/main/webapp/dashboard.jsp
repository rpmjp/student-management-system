<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Dashboard - Student Management System</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    body { font-family: Arial, sans-serif; max-width: 1200px; margin: 40px auto; padding: 20px; background: #f5f5f5; }
    h1 { color: #333; }
    nav { background: #333; padding: 10px 20px; border-radius: 8px; margin-bottom: 30px; }
    nav a { color: white; text-decoration: none; margin-right: 20px; font-size: 16px; }
    nav a:hover { text-decoration: underline; }
    .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
    .stat-card { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); text-align: center; }
    .stat-number { font-size: 42px; font-weight: bold; margin: 10px 0; }
    .stat-label { color: #666; font-size: 14px; text-transform: uppercase; letter-spacing: 1px; }
    .stat-students .stat-number { color: #4CAF50; }
    .stat-courses .stat-number { color: #2196F3; }
    .stat-enrollments .stat-number { color: #FF9800; }
    .stat-gpa .stat-number { color: #9C27B0; }
    .charts-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-bottom: 30px; }
    .chart-card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
    .chart-card h3 { margin-top: 0; color: #333; }
    canvas { max-height: 300px; }
  </style>
</head>
<body>
<nav>
  <a href="dashboard">Dashboard</a>
  <a href="students">Students</a>
  <a href="courses">Courses</a>
  <a href="enrollments">Enrollments</a>
</nav>

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

<script>
  // Grade Distribution - Bar Chart
  new Chart(document.getElementById('gradeChart'), {
    type: 'bar',
    data: {
      labels: ['A Range', 'B Range', 'C Range', 'D Range', 'F'],
      datasets: [{
        label: 'Number of Grades',
        data: [${gpaA}, ${gpaB}, ${gpaC}, ${gpaD}, ${gpaF}],
        backgroundColor: ['#4CAF50', '#2196F3', '#FF9800', '#FFC107', '#f44336']
      }]
    },
    options: {
      responsive: true,
      plugins: { legend: { display: false } },
      scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
    }
  });

  // Graded vs Ungraded - Doughnut Chart
  new Chart(document.getElementById('gradedChart'), {
    type: 'doughnut',
    data: {
      labels: ['Graded', 'Ungraded'],
      datasets: [{
        data: [${graded}, ${ungraded}],
        backgroundColor: ['#4CAF50', '#BDBDBD']
      }]
    },
    options: { responsive: true }
  });

  // Enrollments per Course - Bar Chart
  new Chart(document.getElementById('courseChart'), {
    type: 'bar',
    data: {
      labels: [<c:forEach var="entry" items="${courseEnrollments}" varStatus="status">'${entry.key}'<c:if test="${!status.last}">,</c:if></c:forEach>],
      datasets: [{
        label: 'Students Enrolled',
        data: [<c:forEach var="entry" items="${courseEnrollments}" varStatus="status">${entry.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
        backgroundColor: '#2196F3'
      }]
    },
    options: {
      responsive: true,
      plugins: { legend: { display: false } },
      scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
    }
  });

  // Students by Major - Pie Chart
  new Chart(document.getElementById('majorChart'), {
    type: 'pie',
    data: {
      labels: [<c:forEach var="entry" items="${majorDistribution}" varStatus="status">'${entry.key}'<c:if test="${!status.last}">,</c:if></c:forEach>],
      datasets: [{
        data: [<c:forEach var="entry" items="${majorDistribution}" varStatus="status">${entry.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
        backgroundColor: ['#4CAF50', '#2196F3', '#FF9800', '#9C27B0', '#f44336', '#00BCD4', '#E91E63', '#795548']
      }]
    },
    options: { responsive: true }
  });
</script>
</body>
</html>