<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FuelPro</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/Home.css"> <!-- Link to external CSS file -->
    <style>
        /* Ensure background loads even if CSS caching interferes */
        body {
            background-image: url('<%= request.getContextPath() %>/assets/images/Home_Background.jpg');
            background-size: cover;
            background-position: center;
        }
    </style>
</head>
<body>

    <div class="wrapper">
        <div class="header">
            <img src="${pageContext.request.contextPath}/assets/images/Logo.png" alt="FuelPro Logo" class="logo"> <!-- Add your logo here -->
            FuelPro
        </div>

        <div class="navbar">
            <div class="navbar-items">
                <a href="${pageContext.request.contextPath}/Help.jsp">Help</a>
            </div>
        </div>

        <div class="description">
            <h2>Us</h2>
            <p>FuelPro: Empowering efficient journeys, one drop at a time.</p>
        </div>

        <div class="container">
            <div class="box" onclick="window.location.href='<%= request.getContextPath() %>/pages/auth/login.jsp';">
                <h2>Sign In</h2>
                <p>→</p>
                <p>Access your account and manage your vehicle needs with ease.</p>
            </div>
            <div class="box" onclick="window.location.href='<%= request.getContextPath() %>/pages/auth/register.jsp';">
                <h2>Sign Up</h2>
                <p>→</p>
                <p>Don't have an account? Join Us!</p>
            </div>
        </div>
        
        <div class="container">
            <div class="box" onclick="window.location.href='<%= request.getContextPath() %>/Help.jsp';">
                <h2>Help</h2>
                <p>Need assistance? Click here!</p>
            </div>
        </div>

        <div class="footer">
            <p>&copy; 2024 FuelPro. All rights reserved.</p>
        </div>
    </div>

</body>
</html>
