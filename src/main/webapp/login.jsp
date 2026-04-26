<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Login - Student Management System</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
  <script src="${pageContext.request.contextPath}/css/theme.js"></script>
  <style>
    body { display: flex; justify-content: center; align-items: center; min-height: 100vh; }
    .login-container { width: 100%; max-width: 420px; padding: 20px; }
    .login-card {
      background: var(--bg-card);
      border-radius: 20px;
      padding: 40px;
      box-shadow: var(--shadow-lg);
      border: 1px solid var(--border);
    }
    .login-header { text-align: center; margin-bottom: 32px; }
    .login-logo { font-size: 48px; margin-bottom: 8px; }
    .login-title { font-size: 24px; font-weight: 700; color: var(--text-primary); margin-bottom: 4px; }
    .login-subtitle { color: var(--text-muted); font-size: 14px; }
    .form-group { margin-bottom: 20px; }
    .form-group label {
      display: block; font-size: 12px; font-weight: 600; color: var(--text-secondary);
      margin-bottom: 6px; text-transform: uppercase; letter-spacing: 1px;
    }
    .form-group input {
      width: 100%; padding: 14px; border: 2px solid var(--border); border-radius: 12px;
      font-size: 16px; background: var(--bg-card); color: var(--text-primary); transition: border 0.2s, box-shadow 0.2s;
    }
    .form-group input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(45, 212, 168, 0.15); }
    .form-group input::placeholder { color: var(--text-muted); }
    .btn-login {
      width: 100%; padding: 14px; background: var(--primary); color: var(--primary-text);
      border: none; border-radius: 12px; font-size: 16px; font-weight: 700;
      cursor: pointer; transition: background 0.2s, transform 0.2s;
    }
    .btn-login:hover { background: var(--primary-hover); transform: translateY(-1px); }
    .login-error {
      background: rgba(244, 67, 54, 0.1); color: var(--danger); padding: 12px 16px;
      border-radius: 10px; margin-bottom: 20px; font-size: 14px; text-align: center;
      border: 1px solid rgba(244, 67, 54, 0.2);
    }
    .login-footer { text-align: center; margin-top: 24px; color: var(--text-muted); font-size: 13px; line-height: 1.8; }
    .login-theme-toggle {
      position: fixed; top: 20px; right: 20px; background: none; border: 1px solid var(--border);
      color: var(--text-muted); padding: 8px 12px; border-radius: 8px; cursor: pointer;
      font-size: 16px; transition: all 0.2s;
    }
    .login-theme-toggle:hover { border-color: var(--primary); color: var(--primary); }
    @media (max-width: 600px) {
      .login-container { padding: 16px; }
      .login-card { padding: 28px 24px; border-radius: 16px; }
      .login-logo { font-size: 40px; }
      .login-title { font-size: 20px; }
    }
  </style>
</head>
<body>
<button class="login-theme-toggle" id="themeToggle"></button>

<div class="login-container">
  <div class="login-card">
    <div class="login-header">
      <div class="login-logo">🎓</div>
      <div class="login-title">Student Management System</div>
      <div class="login-subtitle">Sign in to your account</div>
    </div>

    <c:if test="${not empty error}">
      <div class="login-error">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">
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
    </div>
  </div>
</div>
</body>
</html>