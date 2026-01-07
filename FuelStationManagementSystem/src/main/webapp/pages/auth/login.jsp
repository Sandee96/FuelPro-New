<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <style>
        body {
            background-image: url('../../assets/images/Home_Background.jpg'); /* Replace with your image URL */
            background-size: cover; /* Cover the entire background */
            background-position: center; /* Center the background image */
            background-repeat: no-repeat; /* Prevent image repetition */
            min-height: 100vh; /* Full height of the viewport */
            margin: 0; /* Remove default margin */
            font-family: Arial, sans-serif; /* Set font for the page */
        }
        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
            width: 240px;
            background: #111; /* slightly softer than pure black to match header/footer tone */
            color: #fff;
            padding: 24px 18px;
            box-shadow: 2px 0 8px rgba(0, 0, 0, 0.2);
            display: flex;
            flex-direction: column;
            gap: 14px;
            box-sizing: border-box;
        }
        .sidebar-title {
            font-size: 24px;
            font-weight: 800;
            margin-bottom: 10px;
        }
        .sidebar a {
            color: #fff;
            text-decoration: none;
            padding: 10px 12px;
            border-radius: 8px;
            font-weight: 600;
            display: block;
        }
        .sidebar a:hover {
            background: rgba(255, 255, 255, 0.15);
        }
        .main-area {
            margin-left: 260px;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            box-sizing: border-box;
        }
        .container {
            width: 400px; /* Fixed width for the form */
            height: 400px; /* Fixed height for the form to make it square */
            padding: 15px; /* Equal padding around the container */
            background-color: rgba(255, 255, 255, 0.6); /* Increased transparency (0.6) */
            border-radius: 8px; /* Rounded corners */
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5); /* Shadow effect */
            display: flex; /* Use flexbox for inner layout */
            flex-direction: column; /* Arrange children in a column */
            justify-content: center; /* Center items vertically */
            align-items: center; /* Center items horizontally */
        }
        .card-title {
            text-align: center; /* Center the title text */
            color: #000; /* Black title */
            margin: 0; /* Remove default margin */
            margin-bottom: 20px; /* Add space below the title */
        }
        .form-label {
            color: #000; /* Set label text color to black */
            margin-bottom: 5px; /* Margin below the label */
            font-weight: bold; /* Bold text for labels */
            width: 100%; /* Full width for labels */
            text-align: left; /* Align labels to the left */
        }
        .form-control {
            padding: 10px; /* Padding inside the input fields */
            margin-bottom: 15px; /* Margin below each input */
            border: 1px solid #ccc; /* Light border */
            border-radius: 4px; /* Rounded corners for input fields */
            width: 100%; /* Full width for input fields */
            color: #000; /* Set input text color to black */
        }
        .btn-yellow {
            background-color: #ffc107; /* Yellow background for button */
            border: none; /* No border */
            color: #000; /* Black text */
            padding: 10px; /* Padding inside the button */
            cursor: pointer; /* Pointer cursor on hover */
            font-size: 16px; /* Font size */
            border-radius: 4px; /* Rounded corners */
            width: 100%; /* Full width for the button */
        }
        .btn-yellow:hover {
            background-color: #e0a800; /* Darker yellow on hover */
        }
        .alert {
            padding: 10px; /* Padding for alerts */
            margin-top: 15px; /* Margin above alerts */
            border-radius: 4px; /* Rounded corners */
            width: 100%; /* Full width for alerts */
        }
        .alert-danger {
            background-color: #f8d7da; /* Light red background for error */
            color: #721c24; /* Dark red text */
            border: 1px solid #f5c6cb; /* Light red border */
        }
        .register-link {
            text-align: center; /* Center the link */
            margin-top: 15px; /* Margin above the link */
        }
        .register-link a {
            text-decoration: none; /* No underline */
            color: #007bff; /* Link color */
        }
        .register-link a:hover {
            text-decoration: underline; /* Underline on hover */
        }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/form-theme.css">
</head>
<body class="refill-page">

    <div class="sidebar">
        <div class="sidebar-title">FuelPro</div>
        <a href="<%= request.getContextPath() %>/pages/user/HomeLogged.jsp">Home</a>
        <a href="<%= request.getContextPath() %>/pages/user/profile.jsp">Profile</a>
        <a href="<%= request.getContextPath() %>/pages/auth/login.jsp">Login</a>
        <a href="<%= request.getContextPath() %>/pages/auth/register.jsp">Register</a>
        <a href="<%= request.getContextPath() %>/pages/user/Refill.jsp">Refill</a>
        <a href="<%= request.getContextPath() %>/pages/payment/addcart.jsp">Payment</a>
    </div>

    <div class="main-area">
    <div class="refill-wrapper">
    <div class="container">
        <h2 class="card-title">Login</h2>

        <!-- Login Form -->
        <form id="loginForm" onsubmit="handleLogin(event)">
            <div class="mb-3">
                <label for="email" class="form-label">Email:</label>
                <input type="email" id="email" name="email" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password:</label>
                <input type="password" id="password" name="password" class="form-control" required>
            </div>

            <button type="submit" class="btn-yellow">Login</button>

            <!-- Error message -->
            <div id="errorMessage" class="alert alert-danger" style="display:none;"></div>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>

            <!-- Forgot Password Link -->
            <div class="register-link">
                <a href="${pageContext.request.contextPath}/pages/auth/ChangePassword.jsp">Forgot Password?</a>
            </div>

            <!-- Registration Link -->
            <div class="register-link">
                <a href="${pageContext.request.contextPath}/pages/auth/register.jsp">Don't have an account? Register here</a>
            </div>
        </form>
    </div>
    </div>
    </div>

    <script>
        async function handleLogin(event) {
            event.preventDefault();
            const formData = new FormData(event.target);
            const email = formData.get('email');
            const password = formData.get('password');
            
            const contextPath = '<%= request.getContextPath() %>';
            
            try {
                const response = await fetch(contextPath + '/api/auth/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'email=' + encodeURIComponent(email) + '&password=' + encodeURIComponent(password)
                });
                
                const data = await response.json();
                
                if (data.status === 'success') {
                    window.location.href = '../user/HomeLogged.jsp';
                } else {
                    document.getElementById('errorMessage').textContent = data.message;
                    document.getElementById('errorMessage').style.display = 'block';
                }
            } catch (error) {
                document.getElementById('errorMessage').textContent = 'Login failed. Please try again.';
                document.getElementById('errorMessage').style.display = 'block';
            }
        }
    </script>

</body>
</html>
