<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-image: url('https://interwave.lk/wp-content/uploads/2022/03/professional-washer-blue-uniform-washing-luxury-car-with-water-gun-open-air-car-wash-1200x800.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            color: #ffffff;
        }
        .confirmation-container {
            margin: 50px auto;
            padding: 20px;
            background-color: rgba(224, 247, 250, 0.9); /* Semi-transparent background */
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            width: 60%;
            border-radius: 10px;
        }
        .confirmation-header {
            text-align: center;
            margin-bottom: 20px;
            font-size: 2rem;
            color: #0d47a1; /* Dark blue for title */
        }
        .confirmation-label {
            font-size: 1.2rem;
            font-weight: bold;
            color: #0d47a1; /* Dark blue for label names */
        }
        .details-text {
            color: #000000; /* Black color for paragraph text */
        }
        .btn-primary {
            background-color: #0d47a1;
            border-color: #0d47a1;
        }
        .btn-primary:hover {
            background-color: #0a3b82;
            border-color: #0a3b82;
        }
    </style>
</head>
<body>

<div class="container confirmation-container">
    <h1 class="confirmation-header">Booking Confirmation</h1>

    <div class="mb-3">
        <h5 class="confirmation-label">Your Details:</h5>
        <p class="details-text"><strong>Vehicle Number:</strong> <%= request.getParameter("vehiclenumber") != null ? request.getParameter("vehiclenumber") : "N/A" %></p>
        <p class="details-text"><strong>Service Type:</strong> <%= request.getParameter("servicetype") != null ? request.getParameter("servicetype") : "N/A" %></p>
        <p class="details-text"><strong>Service Station:</strong> <%= request.getParameter("servicestation") != null ? request.getParameter("servicestation") : "N/A" %></p>
        <p class="details-text"><strong>Date:</strong> <%= request.getParameter("date") != null ? request.getParameter("date") : "N/A" %></p>
        <p class="details-text"><strong>Time:</strong> <%= request.getParameter("time") != null ? request.getParameter("time") : "N/A" %></p>
    </div>

    <a href="${pageContext.request.contextPath}/pages/booking/ServiceBooking.jsp" class="btn btn-primary">Book Another Service</a>
    <a href="${pageContext.request.contextPath}/pages/payment/addcart.jsp" class="btn btn-primary">Make Payment</a>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
