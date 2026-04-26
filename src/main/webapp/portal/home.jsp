<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>My Portal - Student Management System</title>
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

    .container { max-width: 1000px; margin: 0 auto; padding: 20px; }

    .welcome-card { background: linear-gradient(135deg, #1a1a2e, #16213e); color: white; padding: 30px; border-radius: 12px; margin-bottom: 24px; }
    .welcome-name { font-size: 28px; font-weight: bold; margin-bottom: 4px; }
    .welcome-id { color: #e94560; font-size: 16px; }
    .welcome-major { color: #aaa; margin-top: 8px; }

    .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 24px; }
    .stat-card { background: white; padding: 24px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); text-align: center; }
    .stat-number { font-size: 36px; font-weight: bold; margin: 8px 0; }
    .stat-label { color: #666; font-size: 13px; text-transform: uppercase; letter-spacing: 1px; }
    .stat-gpa .stat-number { color: #4CAF50; }
    .stat-courses .stat-number { color: #2196F3; }
    .stat-credits .stat-number { color: #FF9800; }

    .card { background: white; padding: 24px; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    .card h2 { font-size: 20px; margin-bottom: 16px; color: #1a1a2e; }

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

    @media (max-width: 900px) {
      .stats-grid { grid-template-columns: repeat(3, 1fr); }
    }

    @media (max-width: 600px) {
      nav { padding: 12px 16px; }
      .nav-brand { font-size: 18px; width: 100%; margin-bottom: 8px; }
      .nav-links { width: 100%; }
      .nav-links a { padding: 6px 12px; font-size: 13px; }
      .nav-user { width: 100%; justify-content: space-between; margin-top: 8px; }
      .container { padding: 12px; }
      .welcome-card { padding: 20px; }
      .welcome-name { font-size: 22px; }
      .stats-grid { grid-template-columns: repeat(3, 1fr); gap: 10px; }
      .stat-card { padding: 16px; }
      .stat-number { font-size: 26px; }
      .stat-label { font-size: 10px; }
      .table-container { display: none; }
      .mobile-cards { display: block; }
    }
  </style>
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
    <a href="${pageContext.request.contextPath}/login?action=logout" class="btn-logout">Logout</a>
  </div>
</nav>

<div class="container">
  <div class="welcome-card">
    <div class="welcome-name">Welcome, ${sessionScope.studentRecord.firstName}!</div>
    <div class="welcome-id">Student ID: ${sessionScope.studentRecord.studentId}</div>
    <div class="welcome-major">${sessionScope.studentRecord.major}</div>
  </div>

  <div class="stats-grid">
    <div class="stat-card stat-gpa">
      <div class="stat-label">Current GPA</div>
      <div class="stat-number">${calculatedGpa}</div>
    </div>
    <div class="stat-card stat-courses">
      <div class="stat-label">Courses</div>
      <div class="stat-number">${totalCourses}</div>
    </div>
    <div class="stat-card stat-credits">
      <div class="stat-label">Credits</div>
      <div class="stat-number">${totalCredits}</div>
    </div>
  </div>

  <div class="card">
    <h2>Current Enrollments</h2>
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
        <c:if test="${empty enrollments}">
          <tr><td colspan="6" style="text-align:center; padding: 30px;">No enrollments yet</td></tr>
        </c:if>
        </tbody>
      </table>
    </div>

    <!-- Mobile Cards -->
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
</body>
</html>