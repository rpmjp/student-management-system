<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Enrollments - Student Management System</title>
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

    .form-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; margin-bottom: 16px; }
    .form-grid select, .form-grid input { padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; width: 100%; transition: border 0.2s; background: white; }
    .form-grid select:focus, .form-grid input:focus { outline: none; border-color: #e94560; }

    .btn { padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-block; transition: all 0.2s; font-weight: 500; }
    .btn-primary { background: #e94560; color: white; }
    .btn-primary:hover { background: #c81e45; }
    .btn-delete { background: #f44336; color: white; padding: 6px 14px; font-size: 13px; }
    .btn-delete:hover { background: #d32f2f; }
    .btn-grade { background: #FF9800; color: white; padding: 6px 14px; font-size: 13px; }
    .btn-grade:hover { background: #F57C00; }

    .table-container { overflow-x: auto; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    table { width: 100%; background: white; border-collapse: collapse; }
    th { background: #1a1a2e; color: white; padding: 14px 12px; text-align: left; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; }
    td { padding: 14px 12px; border-bottom: 1px solid #eee; font-size: 14px; }
    tr:hover { background: #f8f9fa; }
    .actions { display: flex; gap: 6px; flex-wrap: wrap; align-items: center; }

    .grade-form { display: inline-flex; gap: 5px; align-items: center; }
    .grade-form select { padding: 5px 8px; border: 1px solid #ddd; border-radius: 6px; font-size: 13px; }

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
    .mobile-card-actions { display: flex; gap: 8px; margin-top: 12px; flex-wrap: wrap; align-items: center; }
    .mobile-grade-form { display: flex; gap: 6px; align-items: center; flex: 1; }
    .mobile-grade-form select { padding: 8px; border: 1px solid #ddd; border-radius: 6px; font-size: 13px; flex: 1; }

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
  <h1>Enrollment & Grades</h1>

  <div class="card">
    <h2>Enroll Student in Course</h2>
    <form action="enrollments" method="post">
      <div class="form-grid">
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
          <option value="A">A</option>
          <option value="A-">A-</option>
          <option value="B+">B+</option>
          <option value="B">B</option>
          <option value="B-">B-</option>
          <option value="C+">C+</option>
          <option value="C">C</option>
          <option value="C-">C-</option>
          <option value="D+">D+</option>
          <option value="D">D</option>
          <option value="F">F</option>
        </select>
      </div>
      <button type="submit" class="btn btn-primary">Enroll Student</button>
    </form>
  </div>

  <h2 style="margin-bottom: 16px;">All Enrollments (${enrollments.size()})</h2>

  <!-- Desktop Table -->
  <div class="table-container">
    <table>
      <thead>
      <tr>
        <th>Student</th>
        <th>Course</th>
        <th>Credits</th>
        <th>Semester</th>
        <th>Grade</th>
        <th>Points</th>
        <th>Actions</th>
      </tr>
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
                <span class="grade-badge no-grade">N/A</span>
              </c:otherwise>
            </c:choose>
          </td>
          <td>${enrollment.gradePoints != null ? enrollment.gradePoints : '-'}</td>
          <td class="actions">
            <form action="enrollments" method="post" class="grade-form">
              <input type="hidden" name="action" value="grade">
              <input type="hidden" name="enrollmentId" value="${enrollment.id}">
              <select name="grade">
                <option value="A">A</option>
                <option value="A-">A-</option>
                <option value="B+">B+</option>
                <option value="B">B</option>
                <option value="B-">B-</option>
                <option value="C+">C+</option>
                <option value="C">C</option>
                <option value="C-">C-</option>
                <option value="D+">D+</option>
                <option value="D">D</option>
                <option value="F">F</option>
              </select>
              <button type="submit" class="btn btn-grade">Set</button>
            </form>
            <a href="enrollments?action=delete&id=${enrollment.id}" class="btn btn-delete"
               onclick="return confirm('Remove this enrollment?');">Drop</a>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty enrollments}">
        <tr><td colspan="7" style="text-align:center; padding: 30px;">No enrollments yet</td></tr>
      </c:if>
      </tbody>
    </table>
  </div>

  <!-- Mobile Cards -->
  <div class="mobile-cards">
    <c:forEach var="enrollment" items="${enrollments}">
      <div class="mobile-card">
        <div class="mobile-card-header">
          <span class="mobile-card-name">${enrollment.studentName}</span>
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
              <span class="grade-badge no-grade">N/A</span>
            </c:otherwise>
          </c:choose>
        </div>
        <div class="mobile-card-row">
          <span class="mobile-card-label">Course</span>
          <span>${enrollment.courseCode}</span>
        </div>
        <div class="mobile-card-row">
          <span class="mobile-card-label">Course Name</span>
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
        <div class="mobile-card-actions">
          <form action="enrollments" method="post" class="mobile-grade-form">
            <input type="hidden" name="action" value="grade">
            <input type="hidden" name="enrollmentId" value="${enrollment.id}">
            <select name="grade">
              <option value="A">A</option>
              <option value="A-">A-</option>
              <option value="B+">B+</option>
              <option value="B">B</option>
              <option value="B-">B-</option>
              <option value="C+">C+</option>
              <option value="C">C</option>
              <option value="C-">C-</option>
              <option value="D+">D+</option>
              <option value="D">D</option>
              <option value="F">F</option>
            </select>
            <button type="submit" class="btn btn-grade">Set</button>
          </form>
          <a href="enrollments?action=delete&id=${enrollment.id}" class="btn btn-delete"
             onclick="return confirm('Remove this enrollment?');">Drop</a>
        </div>
      </div>
    </c:forEach>
    <c:if test="${empty enrollments}">
      <div class="card" style="text-align:center; padding: 30px;">No enrollments yet</div>
    </c:if>
  </div>
</div>
</body>
</html>