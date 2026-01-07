<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FuelPro</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/HomeLogged.css">
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

    <div class="navbar">
        <div class="navbar-items">
            <a href="${pageContext.request.contextPath}/pages/user/HomeLogged.jsp">Home</a>
            <a href="${pageContext.request.contextPath}/pages/user/profile.jsp">User Profile</a>
            <a href="${pageContext.request.contextPath}/pages/user/Refill.jsp">Refill</a>
            <a href="${pageContext.request.contextPath}/pages/booking/ServiceBooking.jsp">Maintenance</a>
            <a href="${pageContext.request.contextPath}/Help.jsp">Help</a>
        </div>
        <div class="logout-box">
            <%
                com.model.UserModel currentUser = (com.model.UserModel) session.getAttribute("currentUser");
                if (currentUser != null) {
                    String displayName = currentUser.getFirstName() + " " + currentUser.getLastName();
                    out.print("Welcome, " + displayName);
                } else {
                    out.print("Welcome, Guest");
                }
            %>
            <a href="${pageContext.request.contextPath}/pages/user/Home.jsp" style="color: white; text-decoration: none; margin-left: 10px;">Log Out</a>
        </div>
    </div>

    <div class="wrapper">
        <div class="header"></div>

        <div class="description">
            <h2>About FuelPro</h2>
            <p>FuelPro is your one-stop solution for fuel station management and vehicle maintenance. We strive to provide the best services and tools for efficient management.</p>
        </div>

        <div class="updates-container">
            <div class="update-box" onclick="window.location.href='<%= request.getContextPath() %>/pages/user/Refill.jsp';">
                <h2>Refill</h2>
                <p>Get fuel refills conveniently.</p>
            </div>
            <div class="update-box" onclick="window.location.href='<%= request.getContextPath() %>/pages/booking/ServiceBooking.jsp';">
                <h2>Maintenance</h2>
                <p>Plan your vehicle maintenance easily.</p>
            </div>
            <div class="update-box" onclick="window.location.href='<%= request.getContextPath() %>/Help.jsp';">
                <h2>Help</h2>
                <p>Need assistance? Find help here.</p>
            </div>
        </div>
    </div>

    <div class="footer">
        <p>&copy; 2024 FuelPro. All rights reserved.</p>
    </div>

</body>
</html>
