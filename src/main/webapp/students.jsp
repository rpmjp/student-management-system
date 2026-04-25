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
        .form-row input, .form-row select { padding: 8px; border: 1px solid #ddd; border-radius: 4px; flex: 1; min-width: 150px; }
        button { background: #4CAF50; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        button:hover { background: #45a049; }
        table { width: 100%; background: white; border-collapse: collapse; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        th { background: #333; color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #eee; }
        tr:hover { background: #f9f9f9; }
    </style>
</head>
<body>
<h1>Student Management System</h1>

<div class="form-container">
    <h2>Add New Student</h2>
    <form action="students" method="post">
        <div class="form-row">
            <input type="text" name="firstName" placeholder="First Name" required>
            <input type="text" name="lastName" placeholder="Last Name" required>
            <input type="email" name="email" placeholder="Email" required>
        </div>
        <div class="form-row">
            <input type="text" name="major" placeholder="Major">
            <input type="number" name="gpa" placeholder="GPA (0.00 - 4.00)" step="0.01" min="0" max="4" required>
            <input type="date" name="enrollmentDate" required>
        </div>
        <button type="submit">Add Student</button>
    </form>
</div>

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
        </tr>
    </c:forEach>
    <c:if test="${empty students}">
        <tr><td colspan="6" style="text-align:center; padding: 30px;">No students yet — add one above!</td></tr>
    </c:if>
    </tbody>
</table>
</body>
</html>