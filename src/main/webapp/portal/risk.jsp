<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Risk Assessment - Student Management System</title>
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

    .container { max-width: 800px; margin: 0 auto; padding: 20px; }
    h1 { font-size: 28px; margin-bottom: 20px; color: #1a1a2e; }

    .risk-card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); text-align: center; }
    .risk-card h2 { margin-bottom: 20px; }
    .risk-status { font-size: 32px; font-weight: bold; margin: 16px 0; }
    .risk-high { color: #f44336; }
    .risk-low { color: #4CAF50; }
    .risk-detail { font-size: 16px; color: #666; margin: 8px 0; }
    .risk-recommendation { background: #f5f5f5; padding: 16px; border-radius: 8px; margin-top: 20px; text-align: left; font-size: 15px; line-height: 1.6; }
    .risk-recommendation strong { color: #1a1a2e; }

    .risk-meter { margin: 24px auto; max-width: 300px; }
    .meter-bar { height: 12px; background: #e0e0e0; border-radius: 6px; overflow: hidden; }
    .meter-fill { height: 100%; border-radius: 6px; transition: width 0.5s; }
    .meter-low { background: linear-gradient(90deg, #4CAF50, #8BC34A); }
    .meter-high { background: linear-gradient(90deg, #FF9800, #f44336); }
    .meter-label { display: flex; justify-content: space-between; margin-top: 6px; font-size: 12px; color: #999; }

    .error-card { background: #FFF3E0; padding: 20px; border-radius: 12px; text-align: center; color: #E65100; }

    @media (max-width: 600px) {
      nav { padding: 12px 16px; }
      .nav-brand { font-size: 18px; width: 100%; margin-bottom: 8px; }
      .nav-links { width: 100%; }
      .nav-links a { padding: 6px 12px; font-size: 13px; }
      .nav-user { width: 100%; justify-content: space-between; margin-top: 8px; }
      .container { padding: 12px; }
      h1 { font-size: 22px; }
      .risk-card { padding: 20px; }
      .risk-status { font-size: 24px; }
    }
  </style>
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
    <a href="${pageContext.request.contextPath}/login?action=logout" class="btn-logout">Logout</a>
  </div>
</nav>

<div class="container">
  <h1>Academic Risk Assessment</h1>

  <div class="risk-card" id="riskCard">
    <h2>Your AI-Powered Assessment</h2>
    <div id="riskResult">Loading...</div>
  </div>
</div>

<script>
  var pred = JSON.parse('${prediction}');
  var html = '';

  if (pred.error) {
    html = '<div class="error-card"><p>Risk assessment service is currently unavailable.</p><p>' + pred.error + '</p></div>';
  } else {
    var riskClass = pred.at_risk ? 'risk-high' : 'risk-low';
    var riskText = pred.at_risk ? 'AT RISK' : 'ON TRACK';
    var meterClass = pred.at_risk ? 'meter-high' : 'meter-low';
    var meterWidth = pred.risk_probability;

    html = '<div class="risk-status ' + riskClass + '">' + riskText + '</div>';
    html += '<div class="risk-meter">';
    html += '<div class="meter-bar"><div class="meter-fill ' + meterClass + '" style="width: ' + meterWidth + '%"></div></div>';
    html += '<div class="meter-label"><span>Low Risk</span><span>High Risk</span></div>';
    html += '</div>';
    html += '<div class="risk-detail"><strong>Confidence:</strong> ' + pred.confidence + '%</div>';
    html += '<div class="risk-detail"><strong>Risk Level:</strong> ' + pred.risk_probability + '%</div>';
    html += '<div class="risk-recommendation"><strong>Recommendation:</strong> ' + pred.recommendation + '</div>';
  }

  document.getElementById('riskResult').innerHTML = html;
</script>
</body>
</html>