<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Students - Student Management System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
    <script src="${pageContext.request.contextPath}/css/theme.js"></script>
</head>
<body>
<nav>
    <a href="${pageContext.request.contextPath}/dashboard" class="nav-brand">SMS</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/students" class="active">Students</a>
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
    <h1>Student Management</h1>

    <c:if test="${not empty prediction}">
        <div class="prediction-card">
            <h2>ML Risk Assessment: ${predictStudent.firstName} ${predictStudent.lastName}</h2>
            <div id="predictionResult"></div>
        </div>
        <script>
            var pred = JSON.parse('${prediction}');
            var html = '';
            if (pred.error) {
                html = '<p>Error: ' + pred.error + '</p>';
            } else {
                var riskClass = pred.at_risk ? 'risk-high' : 'risk-low';
                var riskText = pred.at_risk ? 'AT RISK' : 'NOT AT RISK';
                html = '<p class="' + riskClass + '">' + riskText + '</p>';
                html += '<p><strong>Confidence:</strong> ' + pred.confidence + '%</p>';
                html += '<p><strong>Risk Probability:</strong> ' + pred.risk_probability + '%</p>';
                html += '<p><strong>Recommendation:</strong> ' + pred.recommendation + '</p>';
            }
            document.getElementById('predictionResult').innerHTML = html;
        </script>
    </c:if>

    <c:if test="${not empty message}">
        <div class="msg-success">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="msg-error">${error}</div>
    </c:if>

    <div class="card ${not empty editStudent ? 'edit-mode' : ''}">
        <h2>${not empty editStudent ? 'Edit Student' : 'Add New Student'}</h2>
        <form action="${pageContext.request.contextPath}/students" method="post">
            <c:if test="${not empty editStudent}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${editStudent.id}">
            </c:if>
            <div class="form-grid">
                <input type="text" name="firstName" placeholder="First Name"
                       value="${not empty editStudent ? editStudent.firstName : ''}" required>
                <input type="text" name="lastName" placeholder="Last Name"
                       value="${not empty editStudent ? editStudent.lastName : ''}" required>
                <input type="email" name="email" placeholder="Email"
                       value="${not empty editStudent ? editStudent.email : ''}" required>
                <input type="text" name="major" placeholder="Major"
                       value="${not empty editStudent ? editStudent.major : ''}">
                <input type="number" name="gpa" placeholder="GPA (0.00 - 4.00)" step="0.01" min="0" max="4"
                       value="${not empty editStudent ? editStudent.gpa : ''}" required>
                <input type="date" name="enrollmentDate"
                       value="${not empty editStudent ? editStudent.enrollmentDate : ''}" required>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    ${not empty editStudent ? 'Update Student' : 'Add Student'}
                </button>
                <c:if test="${not empty editStudent}">
                    <a href="${pageContext.request.contextPath}/students" class="btn btn-cancel">Cancel</a>
                </c:if>
            </div>
        </form>
    </div>

    <div class="card">
        <form class="search-bar" action="${pageContext.request.contextPath}/students" method="get">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" placeholder="Search by name, email, or major..." value="${searchKeyword}">
            <button type="submit" class="btn btn-search">Search</button>
            <a href="${pageContext.request.contextPath}/students" class="btn btn-clear">Clear</a>
        </form>
    </div>

    <c:if test="${not empty searchKeyword}">
        <div class="search-info">
            <span>Results for "<strong>${searchKeyword}</strong>" (${students.size()} found)</span>
            <a href="${pageContext.request.contextPath}/students">Show All</a>
        </div>
    </c:if>

    <h2 style="margin-bottom: 16px;">All Students (${students.size()})</h2>

    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Student ID</th>
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
                    <td>${student.studentId}</td>
                    <td>${student.firstName} ${student.lastName}</td>
                    <td>${student.email}</td>
                    <td>${student.major}</td>
                    <td>${student.gpa}</td>
                    <td>${student.enrollmentDate}</td>
                    <td class="actions">
                        <a href="${pageContext.request.contextPath}/students?action=predict&id=${student.id}" class="btn btn-predict">Risk</a>
                        <a href="${pageContext.request.contextPath}/students?action=edit&id=${student.id}" class="btn btn-edit">Edit</a>
                        <a href="${pageContext.request.contextPath}/students?action=delete&id=${student.id}" class="btn btn-delete"
                           onclick="return confirm('Delete this student?');">Delete</a>
                        <a href="${pageContext.request.contextPath}/students?action=resetpw&id=${student.id}" class="btn btn-reset"
                           onclick="return confirm('Reset password for ${student.firstName} ${student.lastName}?');">Reset PW</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty students}">
                <tr><td colspan="8" style="text-align:center; padding: 30px;">No students found</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <div class="mobile-cards">
        <c:forEach var="student" items="${students}">
            <div class="mobile-card">
                <div class="mobile-card-header">
                    <span class="mobile-card-name">${student.firstName} ${student.lastName}</span>
                    <span class="mobile-card-id">${student.studentId}</span>
                </div>
                <div class="mobile-card-row"><span class="mobile-card-label">Email</span><span>${student.email}</span></div>
                <div class="mobile-card-row"><span class="mobile-card-label">Major</span><span>${student.major}</span></div>
                <div class="mobile-card-row"><span class="mobile-card-label">GPA</span><span>${student.gpa}</span></div>
                <div class="mobile-card-row"><span class="mobile-card-label">Enrolled</span><span>${student.enrollmentDate}</span></div>
                <div class="mobile-card-actions">
                    <a href="${pageContext.request.contextPath}/students?action=predict&id=${student.id}" class="btn btn-predict">Risk</a>
                    <a href="${pageContext.request.contextPath}/students?action=edit&id=${student.id}" class="btn btn-edit">Edit</a>
                    <a href="${pageContext.request.contextPath}/students?action=delete&id=${student.id}" class="btn btn-delete"
                       onclick="return confirm('Delete this student?');">Delete</a>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty students}">
            <div class="card" style="text-align:center; padding: 30px;">No students found</div>
        </c:if>
    </div>
</div>
</body>
</html>