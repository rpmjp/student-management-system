<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>My Grades - Student Management System</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

    .container { max-width: 1000px; margin: 0 auto; padding: 20px; }
    h1 { font-size: 28px; margin-bottom: 20px; color: #1a1a2e; }

    .gpa-card { background: linear-gradient(135deg, #4CAF50, #2E7D32); color: white; padding: 30px; border-radius: 12px; margin-bottom: 24px; text-align: center; }
    .gpa-number { font-size: 56px; font-weight: bold; }
    .gpa-label { font-size: 16px; opacity: 0.9; margin-top: 4px; }

    .card { background: white; padding: 24px; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    .card h2 { font-size: 20px; margin-bottom: 16px; color: #1a1a2e; }
    canvas { max-height: 250px; }

    .table-container { overflow-x: auto; }
    table { width: 100%; border-collapse: collapse; }
    th { background: #1a1a2e; color: white; padding: 12px; text-align: left; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; }
    td { padding: 12px; border-bottom: 1px solid #eee; font-size: 14px; }
    tr:hover { background: #f8f9fa; }

    .grade-badge { padding: 4px 12px; border-radius: 12px; font-weight: 600; font-size: 13px; display: inline-block; }
    .grade-a { background: #E8F5E9; color: #2E7D32; }
    .grade-b { background: #E3F2FD; color: #1565C0; }
    .grade-c { background: #FFF3E0; color: #E65100; }
    .grade-d { background: #FFF8E1; color: #F57F17; }
    .grade-f { background: #FFEBEE; color: #C62828; }
    .no-grade { background: #ECEFF1; color: #546E7A; }

    .mobile-cards { display: none; }
    .mobile-card { background: white; border-radius: 12px; padding: 16px; margin-bottom: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    .mobile-card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
    .mobile-card-name { font-weight: bold; font-size: 16px; color: #1a1a2e; }
    .mobile-card-row { display: flex; justify-content: space-between; padding: 6px 0; border-bottom: 1px solid #f0f0f0; font-size: 14px; }
    .mobile-card-label { color: #666; }

    @media (max-width: 600px) {
      nav { padding: 12px 16px; }
      .nav-brand { font-size: 18px; width: 100%; margin-bottom: 8px; }
      .nav-links { width: 100%; }
      .nav-links a { padding: 6px 12px; font-size: 13px; }
      .nav-user { width: 100%; justify-content: space-between; margin-top: 8px; }
      .container { padding: 12px; }
      h1 { font-size: 22px; }
      .gpa-card { padding: 20px; }
      .gpa-number { font-size: 40px; }
      .table-container { display: none; }
      .mobile-cards { display: block; }
    }
  </style>
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
    <a href="${pageContext.request.contextPath}/login?action=logout" class="btn-logout">Logout</a>
  </div>
</nav>

<div class="container">
  <h1>My Grades</h1>

  <div class="gpa-card">
    <div class="gpa-number">${calculatedGpa}</div>
    <div class="gpa-label">Cumulative GPA</div>
  </div>

  <div class="card">
    <h2>Grade Breakdown</h2>
    <canvas id="gradeChart"></canvas>
  </div>

  <div class="card">
    <h2>All Courses</h2>
    <div class="table-container">
      <table>
        <thead>
        <tr>
          <th>Course</th>
          <th>Name</th>
          <th>Credits</th>
          <th>Semester</th>
          <th>Grade</th>
          <th>Points</th>
        </tr>
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
                <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('A')}">
                  <span class="grade-badge grade-a">${enrollment.grade}</span>
                </c:when>
                <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('B')}">
                  <span class="grade-badge grade-b">${enrollment.grade}</span>
                </c:when>
                <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('C')}">
                  <span class="grade-badge grade-c">${enrollment.grade}</span>
                </c:when>
                <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('D')}">
                  <span class="grade-badge grade-d">${enrollment.grade}</span>
                </c:when>
                <c:when test="${enrollment.grade == 'F'}">
                  <span class="grade-badge grade-f">${enrollment.grade}</span>
                </c:when>
                <c:otherwise>
                  <span class="grade-badge no-grade">Pending</span>
                </c:otherwise>
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
              <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('A')}">
                <span class="grade-badge grade-a">${enrollment.grade}</span>
              </c:when>
              <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('B')}">
                <span class="grade-badge grade-b">${enrollment.grade}</span>
              </c:when>
              <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('C')}">
                <span class="grade-badge grade-c">${enrollment.grade}</span>
              </c:when>
              <c:when test="${not empty enrollment.grade and enrollment.grade.startsWith('D')}">
                <span class="grade-badge grade-d">${enrollment.grade}</span>
              </c:when>
              <c:when test="${enrollment.grade == 'F'}">
                <span class="grade-badge grade-f">${enrollment.grade}</span>
              </c:when>
              <c:otherwise>
                <span class="grade-badge no-grade">Pending</span>
              </c:otherwise>
            </c:choose>
          </div>
          <div class="mobile-card-row">
            <span class="mobile-card-label">Course</span>
            <span>${enrollment.courseName}</span>
          </div>
          <div class="mobile-card-row">
            <span class="mobile-card-label">Credits</span>
            <span>${enrollment.credits}</span>
          </div>
          <div class="mobile-card-row">
            <span class="mobile-card-label">Semester</span>
            <span>${enrollment.semester}</span>
          </div>
          <div class="mobile-card-row">
            <span class="mobile-card-label">Points</span>
            <span>${enrollment.gradePoints != null ? enrollment.gradePoints : '-'}</span>
          </div>
        </div>
      </c:forEach>
    </div>
  </div>
</div>

<script>
  var grades = {};
  <c:forEach var="enrollment" items="${enrollments}">
  <c:if test="${not empty enrollment.grade}">
  var g = '${enrollment.grade}';
  var category = g.startsWith('A') ? 'A' : g.startsWith('B') ? 'B' : g.startsWith('C') ? 'C' : g.startsWith('D') ? 'D' : 'F';
  grades[category] = (grades[category] || 0) + 1;
  </c:if>
  </c:forEach>

  new Chart(document.getElementById('gradeChart'), {
    type: 'bar',
    data: {
      labels: Object.keys(grades),
      datasets: [{
        label: 'Grades',
        data: Object.values(grades),
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
</script>
</body>
</html>