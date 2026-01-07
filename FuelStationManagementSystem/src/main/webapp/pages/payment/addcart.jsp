<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment - Payment</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('../../assets/images/PaymentBG.jpg'); /* Replace with your image URL */
            background-size: cover;
            background-position: center;
            margin: 0;
            padding: 0;
        }

        .form-container {
            background-color: rgba(255, 255, 255, 0.9);
            max-width: 500px;
            margin: 50px auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        table td {
            padding: 10px;
        }

        input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 10px;
        }

        input[type="submit"] {
            width: 100%;
            background-color: #007BFF;
            color: white;
            padding: 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1.2em;
            transition: background-color 0.3s ease;
            margin-top: 20px;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .form-table {
            width: 100%;
        }

        /* Adjust the label column width */
        .form-table td:first-child {
            width: 30%;
            font-weight: bold;
            color: #555;
        }

        /* Styling for better visibility and layout */
        .form-table td:last-child input {
            background-color: #f9f9f9;
            box-shadow: inset 0px 2px 5px rgba(0, 0, 0, 0.1);
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
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/form-theme.css">
</head>
<%
    // Pre-fill amount from previous step if available
    String refillAmount = request.getParameter("amount");
    if (refillAmount == null) {
        refillAmount = "";
    }
%>
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
<div class="form-container">
    <h2>Enter Card Details</h2>
    <form id="paymentForm" onsubmit="handlePayment(event)">
        <table class="form-table">
            <tr>
                <td>Card Type:</td>
                <td> 
                    <select name="cardtype" required>
                        <option value="" disabled selected>Select Card Type</option>
                        <option value="Visa">Visa</option>
                        <option value="MasterCard">MasterCard</option>
                        <option value="American Express">American Express</option>
                        <option value="Discover">Discover</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>Card holder Name:</td>
                <td><input type="text" name="cardholdername" required></td>
            </tr>
            <tr>
                <td>Card Number:</td>
                <td><input type="text" name="cardnumber" required></td>
            </tr>
            <tr>
                <td>Expiration Month (MM):</td>
                <td> 
                    <select name="expmonth" required>
                        <option value="" disabled selected>Select Month</option>
                        <option value="01">January</option>
                        <option value="02">February</option>
                        <option value="03">March</option>
                        <option value="04">April</option>
                        <option value="05">May</option>
                        <option value="06">June</option>
                        <option value="07">July</option>
                        <option value="08">August</option>
                        <option value="09">September</option>
                        <option value="10">October</option>
                        <option value="11">November</option>
                        <option value="12">December</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>Expiration Year (YYYY):</td>
                <td><input type="text" name="expyear" required></td>
            </tr>
            <tr>
                <td>CVN:</td>
                <td><input type="text" name="cvn" required></td>
            </tr>
            <tr>
                <td>Amount :</td>
                <td><input type="text" name="amount" value="<%= refillAmount %>" required></td>
            </tr>
        </table>

        <!-- Submit button -->
        <input type="submit" value="Submit">
    </form>
    <div id="paymentMessage" style="display:none; margin-top: 20px; padding: 10px; border-radius: 5px; text-align: center;"></div>
</div>
</div>
</div>

<script>
    async function handlePayment(event) {
        event.preventDefault();
        const formData = new FormData(event.target);
        
        try {
            const contextPath = '<%= request.getContextPath() %>';
            const response = await fetch(contextPath + '/api/payment/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams(formData)
            });
            
            const data = await response.json();
            const messageDiv = document.getElementById('paymentMessage');
            
            if (data.status === 'success') {
                messageDiv.style.display = 'block';
                messageDiv.style.backgroundColor = '#d4edda';
                messageDiv.style.color = '#155724';
                messageDiv.textContent = data.message;
                setTimeout(() => {
                    window.location.href = '<%= request.getContextPath() %>/pages/user/HomeLogged.jsp';
                }, 1500);
            } else {
                messageDiv.style.display = 'block';
                messageDiv.style.backgroundColor = '#f8d7da';
                messageDiv.style.color = '#721c24';
                messageDiv.textContent = data.message;
            }
        } catch (error) {
            const messageDiv = document.getElementById('paymentMessage');
            messageDiv.style.display = 'block';
            messageDiv.style.backgroundColor = '#f8d7da';
            messageDiv.style.color = '#721c24';
            messageDiv.textContent = 'Payment failed. Please try again.';
        }
    }
</script>

</body>
</html>
