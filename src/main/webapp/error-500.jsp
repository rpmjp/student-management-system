<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
  <title>500 - Server Error</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', Arial, sans-serif; background: #1a1a2e; display: flex; justify-content: center; align-items: center; min-height: 100vh; color: white; text-align: center; }
    .error-container { padding: 40px; }
    .error-code { font-size: 120px; font-weight: bold; color: #e94560; line-height: 1; }
    .error-title { font-size: 28px; margin: 16px 0 8px; }
    .error-message { color: #888; font-size: 16px; margin-bottom: 32px; }
    .btn-home { display: inline-block; padding: 12px 32px; background: #e94560; color: white; text-decoration: none; border-radius: 8px; font-size: 16px; font-weight: 600; transition: background 0.2s; }
    .btn-home:hover { background: #c81e45; }
    @media (max-width: 600px) {
      .error-code { font-size: 80px; }
      .error-title { font-size: 22px; }
    }
  </style>
</head>
<body>
<div class="error-container">
  <div class="error-code">500</div>
  <div class="error-title">Something went wrong</div>
  <div class="error-message">An unexpected error occurred. Please try again or contact your administrator.</div>
  <a href="${pageContext.request.contextPath}/login" class="btn-home">Go to Login</a>
</div>
</body>
</html>