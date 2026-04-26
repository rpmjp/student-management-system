<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Students - Student Management System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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

        /* Prediction Card */
        .prediction-card { background: white; padding: 20px; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-left: 5px solid #9C27B0; }
        .prediction-card h2 { font-size: 20px; margin-bottom: 10px; }
        .risk-high { color: #f44336; font-weight: bold; font-size: 20px; }
        .risk-low { color: #4CAF50; font-weight: bold; font-size: 20px; }

        /* Cards */
        .card { background: white; padding: 24px; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .card h2 { font-size: 20px; margin-bottom: 16px; color: #1a1a2e; }

        /* Form */
        .form-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin-bottom: 16px; }
        .form-grid input { padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; width: 100%; transition: border 0.2s; }
        .form-grid input:focus { outline: none; border-color: #e94560; }
        .form-actions { display: flex; gap: 10px; }

        /* Buttons */
        .btn { padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-block; transition: all 0.2s; font-weight: 500; }
        .btn-primary { background: #e94560; color: white; }
        .btn-primary:hover { background: #c81e45; }
        .btn-edit { background: #2196F3; color: white; padding: 6px 14px; font-size: 13px; }
        .btn-edit:hover { background: #1976D2; }
        .btn-delete { background: #f44336; color: white; padding: 6px 14px; font-size: 13px; }
        .btn-delete:hover { background: #d32f2f; }
        .btn-predict { background: #9C27B0; color: white; padding: 6px 14px; font-size: 13px; }
        .btn-predict:hover { background: #7B1FA2; }
        .btn-cancel { background: #9E9E9E; color: white; }
        .btn-search { background: #FF9800; color: white; }
        .btn-search:hover { background: #F57C00; }
        .btn-clear { background: #757575; color: white; text-decoration: none; }

        /* Search */
        .search-bar { display: flex; gap: 10px; align-items: center; }
        .search-bar input { flex: 1; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; }
        .search-bar input:focus { outline: none; border-color: #e94560; }
        .search-info { background: #FFF3E0; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px; }

        /* Table */
        .table-container { overflow-x: auto; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        table { width: 100%; background: white; border-collapse: collapse; }
        th { background: #1a1a2e; color: white; padding: 14px 12px; text-align: left; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; }
        td { padding: 14px 12px; border-bottom: 1px solid #eee; font-size: 14px; }
        tr:hover { background: #f8f9fa; }
        .actions { display: flex; gap: 6px; flex-wrap: wrap; }

        /* Edit mode */
        .edit-mode { border-left: 5px solid #2196F3; }

        /* Mobile Cards (hidden by default, shown on mobile) */
        .mobile-cards { display: none; }
        .mobile-card { background: white; border-radius: 12px; padding: 16px; margin-bottom: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .mobile-card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
        .mobile-card-name { font-weight: bold; font-size: 16px; color: #1a1a2e; }
        .mobile-card-id { color: #999; font-size: 13px; }
        .mobile-card-row { display: flex; justify-content: space-between; padding: 6px 0; border-bottom: 1px solid #f0f0f0; font-size: 14px; }
        .mobile-card-label { color: #666; }
        .mobile-card-actions { display: flex; gap: 8px; margin-top: 12px; }
        .mobile-card-actions .btn { flex: 1; text-align: center; }

        /* Responsive */
        @media (max-width: 900px) {
            .form-grid { grid-template-columns: repeat(2, 1fr); }
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
        }

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
            .search-bar { flex-direction: column; }
            .search-bar input { width: 100%; }
            .form-actions { flex-direction: column; }
            .form-actions .btn { width: 100%; text-align: center; }

            /* Hide table, show cards on mobile */
            .table-container { display: none; }
            .mobile-cards { display: block; }
            .prediction-card h2 { font-size: 18px; }
        }

        .nav-user { display: flex; align-items: center; gap: 12px; }
        .nav-username { color: #e94560; font-weight: 600; font-size: 14px; }
        .btn-logout { color: #ccc; text-decoration: none; padding: 6px 14px; border: 1px solid #444; border-radius: 6px; font-size: 13px; transition: all 0.2s; }
        .btn-logout:hover { background: #e94560; color: white; border-color: #e94560; }

        .btn-settings { color: #ccc; text-decoration: none; padding: 6px 14px; border-radius: 6px; font-size: 13px; transition: all 0.2s; }
        .btn-settings:hover { background: #16213e; color: #e94560; }

        .btn-reset { background: #FF9800; color: white; padding: 6px 14px; font-size: 13px; }
        .btn-reset:hover { background: #F57C00; }
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
    <h1>Student Management</h1>

    <!-- Prediction Result -->
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
        <div class="card" style="border-left: 5px solid #4CAF50; margin-bottom: 20px;">
            <p style="color: #2E7D32; font-weight: 500;">${message}</p>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="card" style="border-left: 5px solid #f44336; margin-bottom: 20px;">
            <p style="color: #C62828; font-weight: 500;">${error}</p>
        </div>
    </c:if>

    <!-- Add/Edit Form -->
    <div class="card ${not empty editStudent ? 'edit-mode' : ''}">
        <h2>${not empty editStudent ? 'Edit Student' : 'Add New Student'}</h2>
        <form action="students" method="post">
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
                    <a href="students" class="btn btn-cancel">Cancel</a>
                </c:if>
            </div>
        </form>
    </div>

    <!-- Search -->
    <div class="card">
        <form class="search-bar" action="students" method="get">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" placeholder="Search by name, email, or major..."
                   value="${searchKeyword}">
            <button type="submit" class="btn btn-search">Search</button>
            <a href="students" class="btn btn-clear">Clear</a>
        </form>
    </div>

    <c:if test="${not empty searchKeyword}">
        <div class="search-info">
            <span>Results for "<strong>${searchKeyword}</strong>" (${students.size()} found)</span>
            <a href="students">Show All</a>
        </div>
    </c:if>

    <h2 style="margin-bottom: 16px;">All Students (${students.size()})</h2>

    <!-- Desktop Table -->
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
                        <a href="students?action=predict&id=${student.id}" class="btn btn-predict">Risk</a>
                        <a href="students?action=edit&id=${student.id}" class="btn btn-edit">Edit</a>
                        <a href="students?action=delete&id=${student.id}" class="btn btn-delete"
                           onclick="return confirm('Delete this student?');">Delete</a>
                        <a href="students?action=resetpw&id=${student.id}" class="btn btn-reset"
                           onclick="return confirm('Reset password to default for ${student.firstName} ${student.lastName}?');">Reset PW</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty students}">
                <tr><td colspan="7" style="text-align:center; padding: 30px;">No students found</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <!-- Mobile Cards -->
    <div class="mobile-cards">
        <c:forEach var="student" items="${students}">
            <div class="mobile-card">
                <div class="mobile-card-header">
                    <span class="mobile-card-name">${student.firstName} ${student.lastName}</span>
                    <span class="mobile-card-id">${student.studentId}</span>
                </div>
                <div class="mobile-card-row">
                    <span class="mobile-card-label">Email</span>
                    <span>${student.email}</span>
                </div>
                <div class="mobile-card-row">
                    <span class="mobile-card-label">Major</span>
                    <span>${student.major}</span>
                </div>
                <div class="mobile-card-row">
                    <span class="mobile-card-label">GPA</span>
                    <span>${student.gpa}</span>
                </div>
                <div class="mobile-card-row">
                    <span class="mobile-card-label">Enrolled</span>
                    <span>${student.enrollmentDate}</span>
                </div>
                <div class="mobile-card-actions">
                    <a href="students?action=predict&id=${student.id}" class="btn btn-predict">Risk</a>
                    <a href="students?action=edit&id=${student.id}" class="btn btn-edit">Edit</a>
                    <a href="students?action=delete&id=${student.id}" class="btn btn-delete"
                       onclick="return confirm('Delete this student?');">Delete</a>
                    <a href="students?action=resetpw&id=${student.id}" class="btn btn-reset"
                       onclick="return confirm('Reset password to default for ${student.firstName} ${student.lastName}?');">Reset PW</a>
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