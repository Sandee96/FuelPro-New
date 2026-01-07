<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Refill Details</title>
    <link rel="stylesheet" href="../../assets/css/RefillDetails.css"> <!-- Link to your CSS file -->
</head>
<body>
    <div class="container">
        <h1>Refill Request is Successful!</h1>
        <%
            String fuelStation = request.getParameter("FuelStation");
            String fuelType = request.getParameter("FuelType");
            String amount = request.getParameter("amount");
            String totalPriceStr = request.getParameter("TotalPrice");
            double totalPrice = 0.0;
            if (totalPriceStr != null && !totalPriceStr.isEmpty()) {
                try {
                    totalPrice = Double.parseDouble(totalPriceStr);
                } catch (NumberFormatException e) {
                    totalPrice = 0.0;
                }
            }
        %>
        <p><strong>Fuel Station:</strong> <%= fuelStation != null ? fuelStation : "N/A" %></p>
        <p><strong>Fuel Type:</strong> <%= fuelType != null ? fuelType : "N/A" %></p>
        <p><strong>Amount:</strong> <%= amount != null && !amount.isEmpty() ? amount : "N/A" %></p>

        <%
            int referenceNumber = (int)(Math.random() * 10000);
        %>
        <p><strong>Reference Number:</strong> REF<%= referenceNumber %></p>

        <!-- Cancel request form -->
        <form id="cancelRefillForm" onsubmit="handleCancelRefill(event)">
            <input type="hidden" name="FuelStation" value="<%= fuelStation != null ? fuelStation : "" %>" />
            <input type="hidden" name="FuelType" value="<%= fuelType != null ? fuelType : "" %>" />
            <input type="hidden" name="amount" value="<%= amount != null ? amount : "" %>" />
            <button type="submit">Cancel Request</button>
        </form>

        <!-- Proceed to add cart page -->
        <form action="../payment/addcart.jsp" method="post">
            <input type="hidden" name="FuelStation" value="<%= fuelStation != null ? fuelStation : "" %>" />
            <input type="hidden" name="FuelType" value="<%= fuelType != null ? fuelType : "" %>" />
            <input type="hidden" name="amount" value="<%= amount != null ? amount : "" %>" />
            <button type="submit">Proceed to Checkout</button>
        </form>

        <!-- Message display for record deletion -->
        <c:if test="${not empty message}">
            <p class="message"><strong>${message}</strong></p>
        </c:if>
    </div>

    <script>
        const contextPath = '<%= request.getContextPath() %>';
        
        async function handleCancelRefill(event) {
            event.preventDefault();
            const formData = new FormData(event.target);
            
            try {
                const response = await fetch(contextPath + '/api/refill/delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    credentials: 'include',
                    body: new URLSearchParams(formData)
                });
                
                const data = await response.json();
                
                if (data.status === 'success') {
                    alert(data.message);
                    setTimeout(() => {
                        window.location.href = '<%= request.getContextPath() %>/pages/user/Refill.jsp';
                    }, 500);
                } else {
                    alert(data.message);
                }
            } catch (error) {
                alert('Failed to cancel refill request. Please try again.');
            }
        }
    </script>
</body>
</html>
