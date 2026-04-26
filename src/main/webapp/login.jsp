<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Login - Student Management System</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', Arial, sans-serif; background: #1a1a2e; display: flex; justify-content: center; align-items: center; min-height: 100vh; }

    .login-container { width: 100%; max-width: 420px; padding: 20px; }
    .login-card { background: white; border-radius: 16px; padding: 40px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); }

    .login-header { text-align: center; margin-bottom: 32px; }
    .login-logo { font-size: 48px; margin-bottom: 8px; }
    .login-title { font-size: 24px; font-weight: bold; color: #1a1a2e; margin-bottom: 4px; }
    .login-subtitle { color: #888; font-size: 14px; }

    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; font-size: 13px; font-weight: 600; color: #555; margin-bottom: 6px; text-transform: uppercase; letter-spacing: 0.5px; }
    .form-group input { width: 100%; padding: 14px; border: 2px solid #e0e0e0; border-radius: 10px; font-size: 16px; transition: border 0.2s; }
    .form-group input:focus { outline: none; border-color: #e94560; }
    .form-group input::placeholder { color: #bbb; }

    .btn-login { width: 100%; padding: 14px; background: #e94560; color: white; border: none; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; transition: background 0.2s; }
    .btn-login:hover { background: #c81e45; }

    .error-message { background: #FFEBEE; color: #C62828; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; text-align: center; }

    .login-footer { text-align: center; margin-top: 24px; color: #999; font-size: 13px; }
    .login-footer a { color: #e94560; text-decoration: none; }

    .role-hint { display: flex; gap: 10px; justify-content: center; margin-top: 20px; }
    .role-badge { padding: 4px 12px; border-radius: 12px; font-size: 12px; font-weight: 600; }
    .role-staff { background: #E3F2FD; color: #1565C0; }
    .role-student { background: #E8F5E9; color: #2E7D32; }

    @media (max-width: 600px) {
      .login-container { padding: 16px; }
      .login-card { padding: 28px 24px; }
      .login-logo { font-size: 40px; }
      .login-title { font-size: 20px; }
    }

    .btn-settings { color: #ccc; text-decoration: none; padding: 6px 14px; border-radius: 6px; font-size: 13px; transition: all 0.2s; }
    .btn-settings:hover { background: #16213e; color: #e94560; }
  </style>
</head>
<body>
<div class="login-container">
  <div class="login-card">
    <div class="login-header">
      <div class="login-logo">🎓</div>
      <div class="login-title">Student Management System</div>
      <div class="login-subtitle">Sign in to your account</div>
    </div>

    <c:if test="${not empty error}">
      <div class="error-message">${error}</div>
    </c:if>

    <form action="login" method="post">
      <div class="form-group">
        <label>Username / Student ID</label>
        <input type="text" name="username" placeholder="e.g. jd001 or admin" required autofocus>
      </div>
      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" placeholder="Enter your password" required>
      </div>
      <button type="submit" class="btn-login">Sign In</button>
    </form>

    <div class="login-footer">
      Forgot your password? Contact your administrator to reset it.
      <br><span style="font-size: 11px; color: #bbb;">Default password after reset: Student123!</span>
    </div>
  </div>
</div>
</body>
</html>