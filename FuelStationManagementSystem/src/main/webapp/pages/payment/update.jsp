<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Card List</title>
    <script type="text/javascript">
        window.onload = function() {
            // Check if the message parameter is present in the URL
            const urlParams = new URLSearchParams(window.location.search);
            const message = urlParams.get('message');
            if (message) {
                alert(message);  // Display the alert
            }
        };
    </script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('../../assets/images/PaymentBG.jpg'); /* Replace with your actual image URL */
            background-size: cover;
            background-position: center;
            margin: 0;
            padding: 0;
        }

        .form-container {
            background-color: rgba(255, 255, 255, 0.8); /* Reduced transparency */
            max-width: 500px; /* Set maximum width */
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
            background-color: orange; /* Set button color to orange */
            color: white;
            padding: 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1.2em;
            text-align: center; /* Center align the text */
            transition: background-color 0.3s ease;
            margin-top: 20px; /* Spacing above the button */
        }

        input[type="submit"]:hover {
            background-color: #e68a00; /* Darker shade for hover effect */
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
    </style>
</head>
<body>
    <%
        String id = request.getParameter("id");
        String cardtype = request.getParameter("cardtype");
        String cardholdername = request.getParameter("cardholdername");
        String cardnumber = request.getParameter("cardnumber");
        String expmonth = request.getParameter("expmonth");
        String expyear = request.getParameter("expyear");
        String cvn = request.getParameter("cvn");
        String amount = request.getParameter("amount");
    %>
    <div class="form-container">
        <form id="updatePaymentForm" onsubmit="handleUpdatePayment(event)">
            <div id="messageDiv" style="display:none; padding: 10px; margin-bottom: 10px; border-radius: 5px;"></div>
            <table class="form-table">
                <tr>
                    <td>ID:</td>
                    <td><input type="text" id="id" name="id" value="<%=id%>" readonly></td>
                </tr>
                <tr>
                    <td>Card Type:</td>
                    <td><input type="text" id="cardtype" name="cardtype" value="<%=cardtype != null ? cardtype : ""%>" required></td>
                </tr>
                <tr>
                    <td>Card holder Name:</td>
                    <td><input type="text" id="cardholdername" name="cardholdername" value="<%=cardholdername != null ? cardholdername : ""%>" required></td>
                </tr>
                <tr>
                    <td>Card Number:</td>
                    <td><input type="text" id="cardnumber" name="cardnumber" value="<%=cardnumber != null ? cardnumber : ""%>" required></td>
                </tr>
                <tr>
                    <td>Expiration Month (MM):</td>
                    <td><input type="text" id="expmonth" name="expmonth" value="<%=expmonth != null ? expmonth : ""%>" required></td>
                </tr>
                <tr>
                    <td>Expiration Year (YYYY):</td>
                    <td><input type="text" id="expyear" name="expyear" value="<%=expyear != null ? expyear : ""%>" required></td>
                </tr>
                <tr>   
                    <td>CVN :</td>
                    <td><input type="text" id="cvn" name="cvn" value="<%=cvn != null ? cvn : ""%>" required></td>
                </tr>
                <tr>   
                    <td>Amount :</td>
                    <td><input type="text" id="amount" name="amount" value="<%=amount != null ? amount : ""%>" required></td>
                </tr>
                <tr>
                    <td colspan="2"><input type="submit" value="Submit"></td>
                </tr>
            </table>
        </form>
    </div>

    <script>
        async function handleUpdatePayment(event) {
            event.preventDefault();
            const formData = new FormData(event.target);
            const contextPath = '<%= request.getContextPath() %>';
            
            try {
                const response = await fetch(contextPath + '/api/payment/update', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    credentials: 'include',
                    body: new URLSearchParams(formData)
                });
                
                const data = await response.json();
                const messageDiv = document.getElementById('messageDiv');
                
                if (data.status === 'success') {
                    messageDiv.style.display = 'block';
                    messageDiv.style.backgroundColor = '#d4edda';
                    messageDiv.style.color = '#155724';
                    messageDiv.textContent = data.message;
                    setTimeout(() => {
                        window.location.href = '<%= request.getContextPath() %>/pages/payment/CardDetails.jsp';
                    }, 1500);
                } else {
                    messageDiv.style.display = 'block';
                    messageDiv.style.backgroundColor = '#f8d7da';
                    messageDiv.style.color = '#721c24';
                    messageDiv.textContent = data.message;
                }
            } catch (error) {
                const messageDiv = document.getElementById('messageDiv');
                messageDiv.style.display = 'block';
                messageDiv.style.backgroundColor = '#f8d7da';
                messageDiv.style.color = '#721c24';
                messageDiv.textContent = 'Update failed. Please try again.';
            }
        }
    </script>
</body>
</html>
