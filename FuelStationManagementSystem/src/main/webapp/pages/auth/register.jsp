<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>
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
            background: #111; /* align tone with header/footer */
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
            max-width: 500px; /* Increased width of the form */
            width: 100%; /* Full width for responsiveness */
            padding: 20px; /* Padding around the container */
            background-color: rgba(255, 255, 255, 0.8); /* Increased transparency of the background */
            border-radius: 8px; /* Rounded corners */
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5); /* Shadow effect */
            display: flex; /* Use flexbox for internal layout */
            flex-direction: column; /* Column layout */
        }
        .card-title {
            text-align: center; /* Center the title text */
            margin-bottom: 20px; /* Margin below the title */
        }
        .form-label {
            margin-bottom: 5px; /* Margin below the label */
            font-weight: bold; /* Bold text for labels */
        }
        .form-control {
            width: calc(100% - 10px); /* Full width minus padding for input fields */
            padding: 10px; /* Padding inside input fields */
            margin-bottom: 15px; /* Increased margin below each input */
            border: 1px solid #ccc; /* Light border */
            border-radius: 4px; /* Rounded corners for input fields */
        }
        .btn-yellow {
            background-color: #ffc107; /* Yellow background for button */
            border: none; /* No border */
            color: #000; /* Black text */
            padding: 10px; /* Padding inside the button */
            cursor: pointer; /* Pointer cursor on hover */
            font-size: 16px; /* Font size */
            border-radius: 4px; /* Rounded corners */
            margin-top: 10px; /* Margin above the button */
            width: 100%; /* Full width for the button */
        }
        .btn-yellow:hover {
            background-color: #e0a800; /* Darker yellow on hover */
        }
        .alert {
            padding: 10px; /* Padding for alerts */
            margin-top: 15px; /* Margin above alerts */
            border-radius: 4px; /* Rounded corners */
        }
        .alert-danger {
            background-color: #f8d7da; /* Light red background for error */
            color: #721c24; /* Dark red text */
            border: 1px solid #f5c6cb; /* Light red border */
        }
        .alert-success {
            background-color: #d4edda; /* Light green background for success */
            color: #155724; /* Dark green text */
            border: 1px solid #c3e6cb; /* Light green border */
        }
        .login-link {
            text-align: center; /* Center the link */
            margin-top: 15px; /* Margin above the link */
        }
        .login-link a {
            text-decoration: none; /* No underline */
            color: #007bff; /* Link color */
        }
        .login-link a:hover {
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
        <h2 class="card-title">Register</h2>

        <!-- Form -->
        <form id="registerForm" onsubmit="handleRegister(event)">
            <div class="mb-3">
                <label for="firstName" class="form-label">First Name:</label>
                <input type="text" id="firstName" name="firstName" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="lastName" class="form-label">Last Name:</label>
                <input type="text" id="lastName" name="lastName" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email:</label>
                <input type="email" id="email" name="email" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="mobile" class="form-label">Mobile:</label>
                <input type="text" id="mobile" name="mobile" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password:</label>
                <input type="password" id="password" name="password" class="form-control" required>
            </div>

            <button type="submit" class="btn-yellow">Register</button>

            <!-- Login Link -->
            <div class="login-link">
                <a href="${pageContext.request.contextPath}/pages/auth/login.jsp">Already have an account? Login here</a>
            </div>
        </form>

        <!-- Error and success messages -->
        <div id="messageDiv" class="alert" style="display:none;"></div>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
    </div>
    </div>
    </div>

    <script>
        async function handleRegister(event) {
            event.preventDefault();
            const formData = new FormData(event.target);
            
            try {
                const contextPath = '<%= request.getContextPath() %>';
                const response = await fetch(contextPath + '/api/user/', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: new URLSearchParams(formData)
                });
                
                const data = await response.json();
                const messageDiv = document.getElementById('messageDiv');
                
                if (data.status === 'success') {
                    messageDiv.className = 'alert alert-success';
                    messageDiv.textContent = data.message;
                    messageDiv.style.display = 'block';
                    setTimeout(() => {
                        window.location.href = '../auth/login.jsp';
                    }, 1500);
                } else {
                    messageDiv.className = 'alert alert-danger';
                    messageDiv.textContent = data.message;
                    messageDiv.style.display = 'block';
                }
            } catch (error) {
                const messageDiv = document.getElementById('messageDiv');
                messageDiv.className = 'alert alert-danger';
                messageDiv.textContent = 'Registration failed. Please try again.';
                messageDiv.style.display = 'block';
            }
        }
    </script>

</body>
</html>
