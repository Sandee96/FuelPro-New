<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.io.IOException" %>
<%@ page import="javax.servlet.ServletException" %>

<%
    // Invalidate the session to log out the user
    HttpSession currentSession = request.getSession(false); // Get the current session
    if (currentSession != null) {
        currentSession.invalidate(); // Invalidate the session
    }

    // Optionally, get the context path if needed for redirection
    String contextPath = request.getContextPath();

    // Redirect to the login page or home page after logging out
    response.sendRedirect(contextPath + "/pages/auth/login.jsp");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout</title>
</head>
<body>
    <h2>You have been logged out successfully.</h2>
    <p>You will be redirected to the login page shortly.</p>
    <script>
        // Optional: Redirect after a delay
        setTimeout(function() {
            window.location.href = "<%= request.getContextPath() %>/pages/auth/login.jsp";
        }, 2000); // Redirect after 2 seconds
    </script>
</body>
</html>
