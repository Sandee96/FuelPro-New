<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Service Booking Form</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: url('https://interwave.lk/wp-content/uploads/2022/03/professional-washer-blue-uniform-washing-luxury-car-with-water-gun-open-air-car-wash-1200x800.jpg') no-repeat center center fixed; /* Use your real image path */
            background-size: cover;
            color: white;
            height: 100vh;
        }
        .form-container {
            margin: 50px auto;
            padding: 20px;
            background-color: rgba(224, 247, 250, 0.9); /* Light blue background */
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
           width: 40%; 
            border-radius: 10px;
        }
        .welcome-header {
            text-align: center;
            margin-bottom: 20px;
            font-size: 1.8rem;
            color: #144678;
        }
        .form-title {
             text-align: center;
            margin-bottom: 15px;
            font-size: 1.4rem;
            color: #144678;
        }
        .btn-custom {
            background-color: #144678;
            color: white;
        }
        .form-label {
           color: #144678; 
           font-weight: bold;
       }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/form-theme.css">
</head>
<body class="refill-page">

<div class="refill-wrapper">
<div class="container form-container">
    <h1 class="welcome-header">Welcome to the Fuel-Pro Vehicle Service Booking</h1>

    <form id="bookingForm" onsubmit="handleBooking(event)">
        <h2 class="form-title">Schedule a Service</h2>
        <div id="bookingMessage" class="alert" style="display:none;"></div>
        <div class="mb-3">
            <label for="vehiclenumber" class="form-label">Vehicle Number</label>
            <input type="text" class="form-control" id="vehiclenumber" name="vehiclenumber" placeholder="Enter your vehicle number" required>
        </div>
        <div class="mb-3">
            <label for="servicetype" class="form-label">Service Type</label>
            <select class="form-select" id="servicetype" name="servicetype" required>
                <option value="">Select service type</option>
                <option value="General Service">General Service</option>
                <option value="Oil Change">Oil Change</option>
                <option value="Brake Inspection">Brake Inspection</option>
                <option value="Tyre Rotation">Tyre Rotation</option>
                <option value="Engine Repair">Engine Repair</option>
            </select>
        </div>
        <div class="mb-3">
            <label for="servicestation" class="form-label">Service Station</label>
            <select class="form-select" id="servicestation" name="servicestation" required>
                <option value="">Select service station</option>
                <option value="Colombo">Colombo</option>
                <option value="Gampaha">Gampaha</option>
                <option value="Galle">Galle</option>
                <option value="Kandy">Kandy</option>
                <option value="Matara">Matara</option>
            </select>
        </div>
        <div class="mb-3">
            <label for="date" class="form-label">Date</label>
            <input type="date" class="form-control" id="date" name="date" required>
        </div>
        <div class="mb-3">
            <label for="time" class="form-label">Time</label>
            <input type="time" class="form-control" id="time" name="time" required>
        </div>

        <button type="submit" class="btn btn-custom w-100">Submit Reservation</button>
       
        
    </form>
</div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

<script>
    async function handleBooking(event) {
        event.preventDefault();
        const formData = new FormData(event.target);
        
        try {
            const contextPath = '<%= request.getContextPath() %>';
            const response = await fetch(contextPath + '/api/service/booking', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams(formData)
            });
            
            const data = await response.json();
            const messageDiv = document.getElementById('bookingMessage');
            
            if (data.status === 'success') {
                messageDiv.className = 'alert alert-success';
                messageDiv.textContent = data.message;
                messageDiv.style.display = 'block';
                // Redirect to confirmation page with booking data
                setTimeout(() => {
                    window.location.href = '<%= request.getContextPath() %>/pages/booking/BookingConfirmation.jsp?vehiclenumber=' + encodeURIComponent(data.data.vehiclenumber) + '&servicetype=' + encodeURIComponent(data.data.servicetype) + '&servicestation=' + encodeURIComponent(data.data.servicestation) + '&date=' + encodeURIComponent(data.data.date) + '&time=' + encodeURIComponent(data.data.time);
                }, 1000);
            } else {
                messageDiv.className = 'alert alert-danger';
                messageDiv.textContent = data.message;
                messageDiv.style.display = 'block';
            }
        } catch (error) {
            const messageDiv = document.getElementById('bookingMessage');
            messageDiv.className = 'alert alert-danger';
            messageDiv.textContent = 'Booking failed. Please try again.';
            messageDiv.style.display = 'block';
        }
    }
</script>

</body>
</html>
