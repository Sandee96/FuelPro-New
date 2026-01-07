<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>  
<%
    if(session.getAttribute("admin")==null){
    	response.sendRedirect(request.getContextPath() + "/pages/admin/AdminUI.jsp");
    }
 %>       
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - View Bookings</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .dashboard-container {
            margin: 50px auto;
            padding: 20px;
            background-color: #e0f7fa;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            width: 90%;
        }
        .welcome-header {
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.5rem;
            font-weight: bold;
            color: #343a40;
        }
        .table-container {
            margin-top: 30px;
        }
        .table-title {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 20px;
            color: #343a40;
        }
        .btn-custom {
            background-color: #343a40;
            color: white;
        }
        .navbar-custom {
            background-color: #343a40;
        }
        .navbar-custom .navbar-brand,
        .navbar-custom .nav-link {
            color: white;
        }
        .logout-btn {
            background-color: #dc3545;
            color: white;
        }
    </style>
</head>
<body>

<!-- Navbar with Logout Button -->
<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/pages/admin/AdminDashboard.jsp">Admin Dashboard</a>
        <div class="collapse navbar-collapse justify-content-end">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a href="logout" class="btn logout-btn">Admin Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container dashboard-container">
    <h1 class="welcome-header">Welcome to the Administrator Dashboard</h1>
    <div class="text-start">
       <a href="${pageContext.request.contextPath}/pages/admin/AdminInsert.jsp" class="btn btn-info mx-2">Add New Customer</a>
       <a href="../payment/CardDetails.jsp" class="btn btn-info mx-2">View Payment Table</a>
    </div>

    <div class="table-container">
        <h2 class="table-title">Service Booking Data</h2>
        <div id="loadingMessage" style="text-align: center; padding: 20px;">Loading...</div>
        <table class="table table-striped table-hover" id="servicesTable" style="display:none;">
            <thead class="table-dark">
                <tr>
                    <th scope="col">Booking ID</th>
                    <th scope="col">Vehicle Number</th>
                    <th scope="col">Service Type</th>
                    <th scope="col">Service Station</th>
                    <th scope="col">Date</th>
                    <th scope="col">Time</th>
                    <th scope="col">Actions</th>
                </tr>
            </thead>
            <tbody id="servicesTableBody">
            </tbody>
        </table>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const contextPath = '<%= request.getContextPath() %>';
    
    // Load services on page load
    window.onload = function() {
        loadServices();
    };
    
    async function loadServices() {
        try {
            const response = await fetch(contextPath + '/api/admin/', {
                method: 'GET',
                credentials: 'include'
            });
            
            const data = await response.json();
            
            if (data.status === 'success' && data.data) {
                const tbody = document.getElementById('servicesTableBody');
                tbody.innerHTML = '';
                
                data.data.forEach(function(service) {
                    const row = document.createElement('tr');
                    row.innerHTML = 
                        '<td>' + service.id + '</td>' +
                        '<td>' + service.vehiclenumber + '</td>' +
                        '<td>' + service.servicetype + '</td>' +
                        '<td>' + service.servicestation + '</td>' +
                        '<td>' + service.date + '</td>' +
                        '<td>' + service.time + '</td>' +
                        '<td>' +
                            '<a href="' + contextPath + '/update?id=' + service.id + '" class="btn btn-success btn-sm">Update</a> ' +
                            '<button onclick="deleteService(' + service.id + ')" class="btn btn-danger btn-sm">Delete</button>' +
                        '</td>';
                    tbody.appendChild(row);
                });
                
                document.getElementById('loadingMessage').style.display = 'none';
                document.getElementById('servicesTable').style.display = 'table';
            } else {
                document.getElementById('loadingMessage').textContent = 'Failed to load services. Please refresh.';
            }
        } catch (error) {
            document.getElementById('loadingMessage').textContent = 'Error loading services. Please refresh.';
        }
    }
    
    async function deleteService(id) {
        if (!confirm('Are you sure you want to delete this service?')) {
            return;
        }
        
        try {
            const response = await fetch(contextPath + '/api/admin/service/delete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                credentials: 'include',
                body: 'id=' + id
            });
            
            const data = await response.json();
            
            if (data.status === 'success') {
                loadServices(); // Reload the table
            } else {
                alert(data.message);
            }
        } catch (error) {
            alert('Failed to delete service. Please try again.');
        }
    }
</script>

</body>
</html>
