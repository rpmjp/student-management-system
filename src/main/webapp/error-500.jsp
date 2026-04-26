<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
  <title>500 - Server Error</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
  <script src="${pageContext.request.contextPath}/css/theme.js"></script>
  <style>
    body { display: flex; justify-content: center; align-items: center; min-height: 100vh; text-align: center; }
    .error-code { font-size: 120px; font-weight: 800; color: var(--danger); line-height: 1; }
    .error-title { font-size: 28px; margin: 16px 0 8px; color: var(--text-primary); font-weight: 700; }
    .error-message { color: var(--text-muted); font-size: 16px; margin-bottom: 32px; }
    @media (max-width: 600px) { .error-code { font-size: 80px; } .error-title { font-size: 22px; } }
  </style>
</head>
<body>
<div>
  <div class="error-code">500</div>
  <div class="error-title">Something went wrong</div>
  <div class="error-message">An unexpected error occurred. Please try again or contact your administrator.</div>
  <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Go to Login</a>
</div>
</body>
</html>