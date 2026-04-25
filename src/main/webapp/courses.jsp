<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Courses - Student Management System</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 1000px; margin: 40px auto; padding: 20px; background: #f5f5f5; }
    h1 { color: #333; }
    nav { background: #333; padding: 10px 20px; border-radius: 8px; margin-bottom: 30px; }
    nav a { color: white; text-decoration: none; margin-right: 20px; font-size: 16px; }
    nav a:hover { text-decoration: underline; }
    .form-container { background: white; padding: 20px; border-radius: 8px; margin-bottom: 30px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
    .form-row { display: flex; gap: 10px; margin-bottom: 10px; flex-wrap: wrap; }
    .form-row input, .form-row textarea { padding: 8px; border: 1px solid #ddd; border-radius: 4px; flex: 1; min-width: 150px; }
    .form-row textarea { min-height: 60px; resize: vertical; }
    .btn { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-block; }
    .btn-add { background: #4CAF50; color: white; font-size: 16px; }
    .btn-add:hover { background: #45a049; }
    .btn-delete { background: #f44336; color: white; padding: 6px 12px; }
    .btn-delete:hover { background: #d32f2f; }
    table { width: 100%; background: white; border-collapse: collapse; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
    th { background: #333; color: white; padding: 12px; text-align: left; }
    td { padding: 12px; border-bottom: 1px solid #eee; }
    tr:hover { background: #f9f9f9; }
  </style>
</head>
<body>
<nav>
  <a href="students">Students</a>
  <a href="courses">Courses</a>
  <a href="enrollments">Enrollments</a>
</nav>

<h1>Course Management</h1>

<div class="form-container">
  <h2>Add New Course</h2>
  <form action="courses" method="post">
    <div class="form-row">
      <input type="text" name="courseCode" placeholder="Course Code (e.g. CS602)" required>
      <input type="text" name="courseName" placeholder="Course Name" required>
      <input type="number" name="credits" placeholder="Credits" min="1" max="6" required>
    </div>
    <div class="form-row">
      <textarea name="description" placeholder="Course description (optional)"></textarea>
    </div>
    <button type="submit" class="btn btn-add">Add Course</button>
  </form>
</div>

<h2>All Courses (${courses.size()})</h2>
<table>
  <thead>
  <tr>
    <th>Code</th>
    <th>Name</th>
    <th>Credits</th>
    <th>Description</th>
    <th>Actions</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach var="course" items="${courses}">
    <tr>
      <td>${course.courseCode}</td>
      <td>${course.courseName}</td>
      <td>${course.credits}</td>
      <td>${course.description}</td>
      <td>
        <a href="courses?action=delete&id=${course.id}" class="btn btn-delete"
           onclick="return confirm('Delete this course?');">Delete</a>
      </td>
    </tr>
  </c:forEach>
  <c:if test="${empty courses}">
    <tr><td colspan="5" style="text-align:center; padding: 30px;">No courses yet — add one above!</td></tr>
  </c:if>
  </tbody>
</table>
</body>
</html>