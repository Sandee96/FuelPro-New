<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrator Login - FuelPro</title>
    
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: url('https://media.istockphoto.com/id/1364951753/photo/auto-service-interior-background-with-cars-on-the-lift.jpg?s=612x612&w=0&k=20&c=jd3IpV-koWUZrSHkwSwSdcA-s7bCRwcY233pSQafUJ4=') no-repeat center center fixed; 
            background-size: cover; 
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #73a2d1; 
        }
        .login-container {
            background-color: rgba(255, 255, 255, 0.8); 
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
            text-align: center;
        }
        .app-name {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
        }
        .description-text {
            color: #666;
            margin-bottom: 30px;
        }
        .btn-login {
            background-color: #007bff;
            color: #fff;
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 18px;
        }
        .btn-login:hover {
            background-color: #0056b3;
            color: #fff;
        }
    </style>
</head>
<body>

<div class="login-container">
    <h1 class="app-name">FuelPro Online Vehicle Service and Fuel Station Management System</h1>
    <p class="description-text">Please click the login button below to access the administrator dashboard and manage the system.</p>
    <!-- Form to redirect to login.jsp -->
    <form action="${pageContext.request.contextPath}/pages/admin/AdminLogin.jsp" method="get">
        <!-- Login Button -->
        <button type="submit" class="btn btn-login">Admin Login</button>
    </form>
</div>

<!-- Redirect script to AdminUI.jsp after successful login -->
<script>
    // Assuming successful login
    // Simulate redirection after login validation on login.jsp
    function redirectToAdminUI() {
        window.location.href = "<%= request.getContextPath() %>/pages/admin/AdminUI.jsp";
    }
</script>

<!-- Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
