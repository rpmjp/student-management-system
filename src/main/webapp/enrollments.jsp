<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Enrollments - Student Management System</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 1100px; margin: 40px auto; padding: 20px; background: #f5f5f5; }
    h1 { color: #333; }
    nav { background: #333; padding: 10px 20px; border-radius: 8px; margin-bottom: 30px; }
    nav a { color: white; text-decoration: none; margin-right: 20px; font-size: 16px; }
    nav a:hover { text-decoration: underline; }
    .form-container { background: white; padding: 20px; border-radius: 8px; margin-bottom: 30px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
    .form-row { display: flex; gap: 10px; margin-bottom: 10px; flex-wrap: wrap; }
    .form-row select, .form-row input { padding: 8px; border: 1px solid #ddd; border-radius: 4px; flex: 1; min-width: 150px; }
    .btn { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-block; }
    .btn-add { background: #4CAF50; color: white; font-size: 16px; }
    .btn-add:hover { background: #45a049; }
    .btn-delete { background: #f44336; color: white; padding: 6px 12px; }
    .btn-delete:hover { background: #d32f2f; }
    .btn-grade { background: #FF9800; color: white; padding: 6px 12px; }
    .btn-grade:hover { background: #F57C00; }
    table { width: 100%; background: white; border-collapse: collapse; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
    th { background: #333; color: white; padding: 12px; text-align: left; }
    td { padding: 12px; border-bottom: 1px solid #eee; }
    tr:hover { background: #f9f9f9; }
    .grade-form { display: inline-flex; gap: 5px; align-items: center; }
    .grade-form select { padding: 4px; border: 1px solid #ddd; border-radius: 4px; }
    .grade-badge { padding: 4px 10px; border-radius: 12px; font-weight: bold; font-size: 13px; }
    .grade-a { background: #E8F5E9; color: #2E7D32; }
    .grade-b { background: #E3F2FD; color: #1565C0; }
    .grade-c { background: #FFF3E0; color: #E65100; }
    .grade-d { background: #FFF8E1; color: #F57F17; }
    .grade-f { background: #FFEBEE; color: #C62828; }
    .no-grade { background: #ECEFF1; color: #546E7A; }
    .actions { display: flex; gap: 5px; align-items: center; }
  </style>
</head>
<body>
<nav>
  <a href="dashboard">Dashboard</a>
  <a href="students">Students</a>
  <a href="courses">Courses</a>
  <a href="enrollments">Enrollments</a>
</nav>

<h1>Enrollment & Grade Management</h1>

<div class="form-container">
  <h2>Enroll Student in Course</h2>
  <form action="enrollments" method="post">
    <div class="form-row">
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
    </div>
    <div class="form-row">
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
    <button type="submit" class="btn btn-add">Enroll Student</button>
  </form>
</div>

<h2>All Enrollments (${enrollments.size()})</h2>
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
          <c:when test="${enrollment.grade.startsWith('A')}">
            <span class="grade-badge grade-a">${enrollment.grade}</span>
          </c:when>
          <c:when test="${enrollment.grade.startsWith('B')}">
            <span class="grade-badge grade-b">${enrollment.grade}</span>
          </c:when>
          <c:when test="${enrollment.grade.startsWith('C')}">
            <span class="grade-badge grade-c">${enrollment.grade}</span>
          </c:when>
          <c:when test="${enrollment.grade.startsWith('D')}">
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
</body>
</html>