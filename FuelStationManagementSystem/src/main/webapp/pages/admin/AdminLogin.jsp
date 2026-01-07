<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrator Login - FuelPro</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: url('https://media.istockphoto.com/id/1364951753/photo/auto-service-interior-background-with-cars-on-the-lift.jpg?s=612x612&w=0&k=20&c=jd3IpV-koWUZrSHkwSwSdcA-s7bCRwcY233pSQafUJ4=') no-repeat center center fixed; /* Replace with your image URL */
            background-size: cover; /* Ensure the image covers the background */
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-container {
            background-color: rgba(255, 255, 255, 0.8); /* Slight transparency to make form stand out */
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .app-name {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
        }
        .form-control {
            margin-bottom: 20px;
            border: 2px solid #007bff; /* Custom border color */
            border-radius: 5px; /* Optional: Rounded corners */
        }
        .form-control:focus {
            border-color: #0056b3; /* Border color on focus */
            box-shadow: none; /* Remove default focus shadow */
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/form-theme.css">
</head>
<body class="refill-page">

<div class="refill-wrapper">
<div class="login-container">
    <h1 class="app-name">FuelPro Administrator Login</h1>
    <p class="description-text">Please enter your administrator credentials to access the dashboard.</p>
    
    <!-- Form to redirect to admindashboard.jsp -->
    <form id="adminLoginForm" onsubmit="handleAdminLogin(event)">
        <div class="form-group">
            <input type="text" class="form-control" placeholder="Username" name="username" id="username" required>
        </div>
        <div class="form-group">
            <input type="password" class="form-control" placeholder="Password" name="password" id="password" required>
        </div>
        <button type="submit" class="btn btn-login">Login</button>
        <div id="errorMessage" style="color: red; margin-top: 10px; display: none;"></div>
    </form>
</div>
</div>

<!-- Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    async function handleAdminLogin(event) {
        event.preventDefault();
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;
        const contextPath = '<%= request.getContextPath() %>';
        
        try {
            const response = await fetch(contextPath + '/api/admin/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password)
            });
            
            const data = await response.json();
            
            if (data.status === 'success') {
                window.location.href = '../admin/AdminDashboard.jsp';
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
