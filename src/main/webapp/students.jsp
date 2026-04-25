<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Management System</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 1000px; margin: 40px auto; padding: 20px; background: #f5f5f5; }
        h1 { color: #333; }
        .form-container { background: white; padding: 20px; border-radius: 8px; margin-bottom: 30px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .form-row { display: flex; gap: 10px; margin-bottom: 10px; flex-wrap: wrap; }
        .form-row input { padding: 8px; border: 1px solid #ddd; border-radius: 4px; flex: 1; min-width: 150px; }
        .btn { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-block; }
        .btn-add { background: #4CAF50; color: white; font-size: 16px; }
        .btn-add:hover { background: #45a049; }
        .btn-edit { background: #2196F3; color: white; padding: 6px 12px; }
        .btn-edit:hover { background: #1976D2; }
        .btn-delete { background: #f44336; color: white; padding: 6px 12px; }
        .btn-delete:hover { background: #d32f2f; }
        .btn-cancel { background: #9E9E9E; color: white; }
        .btn-cancel:hover { background: #757575; }
        .btn-search { background: #FF9800; color: white; }
        .btn-search:hover { background: #F57C00; }
        .btn-clear { background: #9E9E9E; color: white; text-decoration: none; padding: 8px 16px; }
        .search-container { background: white; padding: 15px 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); display: flex; gap: 10px; align-items: center; }
        .search-container input { padding: 8px; border: 1px solid #ddd; border-radius: 4px; flex: 1; }
        table { width: 100%; background: white; border-collapse: collapse; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        th { background: #333; color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #eee; }
        tr:hover { background: #f9f9f9; }
        .actions { display: flex; gap: 5px; }
        .edit-mode { border-left: 4px solid #2196F3; }
        .search-info { background: #FFF3E0; padding: 10px 15px; border-radius: 4px; margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center; }
        nav { background: #333; padding: 10px 20px; border-radius: 8px; margin-bottom: 30px; }
        nav a { color: white; text-decoration: none; margin-right: 20px; font-size: 16px; }
        nav a:hover { text-decoration: underline; }
    </style>
</head>
<body>
<nav>
    <a href="dashboard">Dashboard</a>
    <a href="students">Students</a>
    <a href="courses">Courses</a>
    <a href="enrollments">Enrollments</a>
</nav>
<h1>Student Management System</h1>

<!-- Add/Edit Form -->
<div class="form-container ${not empty editStudent ? 'edit-mode' : ''}">
    <h2>${not empty editStudent ? 'Edit Student' : 'Add New Student'}</h2>
    <form action="students" method="post">
        <c:if test="${not empty editStudent}">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${editStudent.id}">
        </c:if>
        <div class="form-row">
            <input type="text" name="firstName" placeholder="First Name"
                   value="${not empty editStudent ? editStudent.firstName : ''}" required>
            <input type="text" name="lastName" placeholder="Last Name"
                   value="${not empty editStudent ? editStudent.lastName : ''}" required>
            <input type="email" name="email" placeholder="Email"
                   value="${not empty editStudent ? editStudent.email : ''}" required>
        </div>
        <div class="form-row">
            <input type="text" name="major" placeholder="Major"
                   value="${not empty editStudent ? editStudent.major : ''}">
            <input type="number" name="gpa" placeholder="GPA (0.00 - 4.00)" step="0.01" min="0" max="4"
                   value="${not empty editStudent ? editStudent.gpa : ''}" required>
            <input type="date" name="enrollmentDate"
                   value="${not empty editStudent ? editStudent.enrollmentDate : ''}" required>
        </div>
        <button type="submit" class="btn btn-add">
            ${not empty editStudent ? 'Update Student' : 'Add Student'}
        </button>
        <c:if test="${not empty editStudent}">
            <a href="students" class="btn btn-cancel">Cancel</a>
        </c:if>
    </form>
</div>

<!-- Search Bar -->
<form class="search-container" action="students" method="get">
    <input type="hidden" name="action" value="search">
    <input type="text" name="keyword" placeholder="Search by name, email, or major..."
           value="${searchKeyword}">
    <button type="submit" class="btn btn-search">Search</button>
    <a href="students" class="btn btn-clear">Clear</a>
</form>

<!-- Search Results Info -->
<c:if test="${not empty searchKeyword}">
    <div class="search-info">
        <span>Showing results for: "<strong>${searchKeyword}</strong>" (${students.size()} found)</span>
        <a href="students">Show All</a>
    </div>
</c:if>

<!-- Students Table -->
<h2>All Students (${students.size()})</h2>
<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Major</th>
        <th>GPA</th>
        <th>Enrolled</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="student" items="${students}">
        <tr>
            <td>${student.id}</td>
            <td>${student.firstName} ${student.lastName}</td>
            <td>${student.email}</td>
            <td>${student.major}</td>
            <td>${student.gpa}</td>
            <td>${student.enrollmentDate}</td>
            <td class="actions">
                <a href="students?action=edit&id=${student.id}" class="btn btn-edit">Edit</a>
                <a href="students?action=delete&id=${student.id}" class="btn btn-delete"
                   onclick="return confirm('Are you sure you want to delete this student?');">Delete</a>
            </td>
        </tr>
    </c:forEach>
    <c:if test="${empty students}">
        <tr><td colspan="7" style="text-align:center; padding: 30px;">No students found</td></tr>
    </c:if>
    </tbody>
</table>
</body>
</html>