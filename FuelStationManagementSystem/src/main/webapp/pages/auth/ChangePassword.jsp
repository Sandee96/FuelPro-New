<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password</title>
    <style>
        body {
            background-image: url('../../assets/images/UserProfileBG.avif');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            color: black;
            font-family: Arial, sans-serif;
            margin: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            border: 1px solid #ffc107;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            background-color: rgba(255, 255, 255, 0.9);
            max-width: 500px;
            width: 100%;
            margin: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            font-size: 12px;
        }
        h2 {
            color: black;
            text-align: center;
            margin-bottom: 15px;
            font-size: 18px;
        }
        .btn-yellow {
            background-color: #ffc107;
            color: black;
            border: none;
            width: 200px;
            padding: 8px;
            border-radius: 5px;
            cursor: pointer;
            display: block;
            margin: 5px auto;
            font-size: 12px;
        }
        .btn-yellow:hover {
            background-color: #e0a800;
        }
        .form-label {
            color: #333;
            font-weight: bold;
        }
        .form-group {
            margin-bottom: 10px;
            width: 100%;
        }
        .form-control {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .alert {
            padding: 8px;
            margin-top: 10px;
            border-radius: 4px;
            font-size: 12px;
            width: 100%;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .back-link {
            text-align: center;
            margin-top: 15px;
        }
        .back-link a {
            text-decoration: none;
            color: #007bff;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/form-theme.css">
</head>
<body class="refill-page">
    <div class="refill-wrapper">
    <div class="container">
        <h2>Change Password</h2>
        
        <%
            com.model.UserModel currentUser = (com.model.UserModel) session.getAttribute("currentUser");
            
            if (currentUser == null) {
        %>
            <p>You need to be logged in to change your password.</p>
            <div class="back-link">
                <a href="login.jsp">Please login first</a>
            </div>
        <%
            } else {
        %>
            <form id="changePasswordForm" onsubmit="handleChangePassword(event)" style="width: 100%;">
                <div class="form-group">
                    <label for="currentPassword" class="form-label">Current Password:</label>
                    <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="newPassword" class="form-label">New Password:</label>
                    <input type="password" id="newPassword" name="newPassword" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Confirm New Password:</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                </div>

                <button type="submit" class="btn-yellow">Change Password</button>
            </form>

            <div id="passwordMessage" class="alert" style="display:none;"></div>

            <div class="back-link">
                <a href="../user/profile.jsp">Back to Profile</a>
            </div>
        <%
            }
        %>
        
    </div>
    </div>

    <script>
        async function handleChangePassword(event) {
            event.preventDefault();
            const formData = new FormData(event.target);
            
            try {
                const contextPath = '<%= request.getContextPath() %>';
                const response = await fetch(contextPath + '/api/user/changepassword', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: new URLSearchParams(formData)
                });
                
                const data = await response.json();
                const messageDiv = document.getElementById('passwordMessage');
                
                if (data.status === 'success') {
                    messageDiv.className = 'alert alert-success';
                    messageDiv.textContent = data.message;
                    messageDiv.style.display = 'block';
                    document.getElementById('changePasswordForm').reset();
                } else {
                    messageDiv.className = 'alert alert-danger';
                    messageDiv.textContent = data.message;
                    messageDiv.style.display = 'block';
                }
            } catch (error) {
                const messageDiv = document.getElementById('passwordMessage');
                messageDiv.className = 'alert alert-danger';
                messageDiv.textContent = 'Password change failed. Please try again.';
                messageDiv.style.display = 'block';
            }
        }
    </script>
</body>
</html>

