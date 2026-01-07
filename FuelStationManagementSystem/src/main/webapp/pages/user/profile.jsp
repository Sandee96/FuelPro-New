<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-state=1.0">
    <title>User Profile</title>
    <style>
        body {
            background-image: url('../../assets/images/UserProfileBG.avif'); /* Replace with your image URL */
            background-size: cover; /* Cover the entire background */
            background-position: center; /* Center the background image */
            background-repeat: no-repeat; /* Prevent image repetition */
            color: black; /* Set text color to black */
            font-family: Arial, sans-serif; /* Set font type to match Register page */
            margin: 0; /* Remove default margin */
            min-height: 100vh; /* Full height of the viewport */
        }
        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
            width: 240px;
            background: #111; /* align with header/footer tone */
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
            border: 1px solid #ffc107; /* Yellow border around container */
            border-radius: 15px; /* More rounded corners */
            padding: 20px; /* Adjusted padding for the container */
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); /* Shadow for depth */
            background-color: rgba(255, 255, 255, 0.9); /* Increased transparency */
            max-width: 600px; /* Maximum width for container */
            width: 100%; /* Allow the container to adjust width */
            margin: 20px; /* Margin for responsiveness */
            display: flex; /* Use flexbox for content layout */
            flex-direction: column; /* Arrange children in a column */
            align-items: center; /* Center items horizontally */
            justify-content: space-between; /* Evenly spread out content */
            font-size: 12px; /* Decreased font size for better fitting */
        }
        h2 {
            color: black; /* Black color for heading */
            text-align: center; /* Center heading */
            margin-bottom: 15px; /* Margin below heading */
            font-size: 18px; /* Font size for heading */
        }
        .btn-yellow {
            background-color: #ffc107; /* Yellow button */
            color: black; /* Black text on yellow buttons */
            border: none;
            width: 200px; /* Set a specific width for buttons */
            padding: 8px; /* Padding for buttons */
            border-radius: 5px; /* Rounded corners */
            cursor: pointer; /* Pointer cursor on hover */
            display: block; /* Block display for buttons */
            margin: 5px auto; /* Center buttons and add margin */
            font-size: 12px; /* Button font size */
        }
        .btn-yellow:hover {
            background-color: #e0a800; /* Darker yellow on hover */
        }
        .form-label {
            color: #333; /* Darker gray for labels */
            font-weight: bold; /* Bold text for labels */
        }
        .form-group {
            margin-bottom: 10px; /* Space between input groups */
            width: 100%; /* Make input groups take full width */
        }
        .form-control {
            width: 100%; /* Full width for input fields */
            padding: 8px; /* Padding inside input fields */
            margin-bottom: 10px; /* Margin below each input */
            border: 1px solid #ccc; /* Light border */
            border-radius: 4px; /* Rounded corners for input fields */
        }
        .alert {
            padding: 8px; /* Padding for alerts */
            margin-top: 10px; /* Margin above alerts */
            border-radius: 4px; /* Rounded corners */
            font-size: 12px; /* Decreased font size for alerts */
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
            margin-top: 10px; /* Margin above the link */
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
        <h2>User Profile</h2>
        
        <%
            // Retrieve the user object from session using scriptlet
            com.model.UserModel currentUser = (com.model.UserModel) session.getAttribute("currentUser");
            
            if (currentUser == null) {
        %>
            <p>No user is currently logged in.</p>
            <div class="login-link">
                <a href="${pageContext.request.contextPath}/pages/auth/login.jsp">Please login to view your profile</a>
            </div>
        <%
            } else {
        %>
            <form id="updateProfileForm" onsubmit="handleUpdateProfile(event)" style="width: 100%;">
                <input type="hidden" name="userId" id="userId" value="<%= currentUser.getUserId() %>">
                
                <div class="form-group">
                    <label for="firstName" class="form-label">First Name:</label>
                    <input type="text" id="firstName" name="firstName" value="<%= currentUser.getFirstName() != null ? currentUser.getFirstName() : "" %>" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="lastName" class="form-label">Last Name:</label>
                    <input type="text" id="lastName" name="lastName" value="<%= currentUser.getLastName() != null ? currentUser.getLastName() : "" %>" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="email" class="form-label">Email:</label>
                    <input type="email" id="email" name="email" value="<%= currentUser.getEmail() != null ? currentUser.getEmail() : "" %>" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="mobile" class="form-label">Mobile:</label>
                    <input type="text" id="mobile" name="mobile" value="<%= currentUser.getMobile() != null ? currentUser.getMobile() : "" %>" class="form-control" required>
                </div>

                <button type="submit" class="btn-yellow">Update</button>
            </form>

            <div id="profileMessage" class="alert" style="display:none; margin-top: 10px;"></div>

            <div class="login-link" style="margin-top: 15px;">
                <a href="${pageContext.request.contextPath}/pages/auth/ChangePassword.jsp">Forgot Password? Change Password</a>
            </div>

            <button onclick="handleDeleteUser()" class="btn-yellow" style="background-color: #dc3545; display:block; margin: 5px auto;">Delete Account</button>

            <form action="${pageContext.request.contextPath}/logout.jsp" method="post" style="display:inline;">
                <button type="submit" class="btn-yellow">Logout</button> <!-- Logout button -->
            </form>
        <%
            }
        %>
        
    </div>
    </div>
    </div>

    <script>
        async function handleUpdateProfile(event) {
            event.preventDefault();
            const formData = new FormData(event.target);
            
            try {
                const contextPath = '<%= request.getContextPath() %>';
                const response = await fetch(contextPath + '/api/user/update', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: new URLSearchParams(formData)
                });
                
                const data = await response.json();
                const messageDiv = document.getElementById('profileMessage');
                
                if (data.status === 'success') {
                    messageDiv.className = 'alert alert-success';
                    messageDiv.textContent = data.message;
                    messageDiv.style.display = 'block';
                    setTimeout(() => {
                        location.reload();
                    }, 1500);
                } else {
                    messageDiv.className = 'alert alert-danger';
                    messageDiv.textContent = data.message;
                    messageDiv.style.display = 'block';
                }
            } catch (error) {
                const messageDiv = document.getElementById('profileMessage');
                messageDiv.className = 'alert alert-danger';
                messageDiv.textContent = 'Update failed. Please try again.';
                messageDiv.style.display = 'block';
            }
        }

        async function handleDeleteUser() {
            if (!confirm('Are you sure you want to delete your account? This action cannot be undone.')) {
                return;
            }
            
            const userId = document.getElementById('userId').value;
            
            try {
                const contextPath = '<%= request.getContextPath() %>';
                const response = await fetch(contextPath + '/api/user/delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `userId=${userId}`
                });
                
                const data = await response.json();
                
                if (data.status === 'success') {
                    alert(data.message);
                    window.location.href = '<%= request.getContextPath() %>/pages/auth/login.jsp';
                } else {
                    alert(data.message);
                }
            } catch (error) {
                alert('Delete failed. Please try again.');
            }
        }
    </script>

</body>
</html>
