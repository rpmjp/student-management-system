<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Risk Assessment - Student Management System</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
  <script src="${pageContext.request.contextPath}/css/theme.js"></script>
</head>
<body>
<nav>
  <a href="${pageContext.request.contextPath}/portal/home" class="nav-brand">SMS</a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/portal/home">Home</a>
    <a href="${pageContext.request.contextPath}/portal/grades">Grades</a>
    <a href="${pageContext.request.contextPath}/portal/risk" class="active">Risk Check</a>
  </div>
  <div class="nav-user">
    <span class="nav-username">${sessionScope.displayName}</span>
    <button id="themeToggle" class="theme-toggle"></button>
    <a href="${pageContext.request.contextPath}/change-password" class="btn-settings">Settings</a>
    <a href="${pageContext.request.contextPath}/login?action=logout" class="btn-logout">Logout</a>
  </div>
</nav>

<div class="container" style="max-width: 800px;">
  <h1>Academic Risk Assessment</h1>

  <div class="risk-card">
    <h2>Your AI-Powered Assessment</h2>
    <div id="riskResult">Loading...</div>
  </div>
</div>

<script>
  var pred = JSON.parse('${prediction}');
  var html = '';
  if (pred.error) {
    html = '<div class="msg-error" style="text-align:center">Risk assessment service is currently unavailable.</div>';
  } else {
    var riskClass = pred.at_risk ? 'risk-high' : 'risk-low';
    var riskText = pred.at_risk ? 'AT RISK' : 'ON TRACK';
    var meterClass = pred.at_risk ? 'meter-high' : 'meter-low';
    html = '<div class="risk-status ' + riskClass + '">' + riskText + '</div>';
    html += '<div class="risk-meter"><div class="meter-bar"><div class="meter-fill ' + meterClass + '" style="width:' + pred.risk_probability + '%"></div></div>';
    html += '<div class="meter-label"><span>Low Risk</span><span>High Risk</span></div></div>';
    html += '<div class="risk-detail"><strong>Confidence:</strong> ' + pred.confidence + '%</div>';
    html += '<div class="risk-detail"><strong>Risk Level:</strong> ' + pred.risk_probability + '%</div>';
    html += '<div class="risk-recommendation"><strong>Recommendation:</strong> ' + pred.recommendation + '</div>';
  }
  document.getElementById('riskResult').innerHTML = html;
</script>
</body>
</html>