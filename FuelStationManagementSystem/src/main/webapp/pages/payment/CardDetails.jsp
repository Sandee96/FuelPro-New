<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if(session.getAttribute("admin")==null){
    	response.sendRedirect(request.getContextPath() + "/pages/admin/AdminLogin.jsp");
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Payment</title>
<style>
    body {
        background-color:#000; 
        color: #fff;
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
    }

    h2 {
        text-align: center;
        padding: 20px;
        color: #fff;
    }

    table {
        width: 85%;
        margin: 0 auto;
        border-collapse: collapse;
        background-color:  #000 ;
        color: #fff;
        border: 1px solid #ccc;
        box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
    }

    th, td {
        padding: 10px;
        text-align: left;
        border: 1px solid #ddd;
    }

    th {
        background-color: #333; 
        color: #fff;
        text-align: center; 
    }

    td {
        background-color: #000;
        text-align: center;  
    }

    input[type="text"] {
        width: 50%;
        padding: 10px;
        margin: 20px auto;
        display: block;
        border-radius: 5px;
        border: 1px solid #ccc;
        font-size: 16px;
    }

    button {
        padding: 10px 20px;
        background-color:  #FF0000;
        color: white;
        border: none;
        cursor: pointer;
        border-radius: 5px;
        
        transition: background-color 0.3s ease;
    }

    button:hover {
        background-color: #0b5ed7; 

    form {
        display: inline;
    }
</style>
</head>
<body>   

<h2>Payment Table</h2>

<input type="text" id="searchInput" placeholder="search..." oninput="filterTable()">

<div id="loadingMessage" style="text-align: center; padding: 20px; color: white;">Loading payments...</div>

<table id="paymentTable" style="display:none;">
	<tr>
		<th>id</th>
		<th>cardType</th>
		<th>cardHoldername</th>
		<th>cardNumber</th>
		<th>expMonth</th>
		<th>expYear</th>
		<th>CVN</th>
		<th>amount</th>
		<th>Action</th>
	</tr>
	<tbody id="paymentTableBody">
	</tbody>
</table>

<script>
    const contextPath = '<%= request.getContextPath() %>';
    
    // Load payments on page load
    window.onload = function() {
        loadPayments();
    };
    
    async function loadPayments() {
        try {
            const response = await fetch(contextPath + '/api/payment/', {
                method: 'GET',
                credentials: 'include'
            });
            
            const data = await response.json();
            
            if (data.status === 'success' && data.data) {
                const tbody = document.getElementById('paymentTableBody');
                tbody.innerHTML = '';
                
                data.data.forEach(function(card) {
                    const row = document.createElement('tr');
                    row.innerHTML = 
                        '<td>' + card.id + '</td>' +
                        '<td>' + card.cardtype + '</td>' +
                        '<td>' + card.cardholdername + '</td>' +
                        '<td>' + card.cardnumber + '</td>' +
                        '<td>' + card.expmonth + '</td>' +
                        '<td>' + card.expyear + '</td>' +
                        '<td>' + card.cvn + '</td>' +
                        '<td>' + card.amount + '</td>' +
                        '<td>' +
                            '<a href="' + contextPath + '/pages/payment/update.jsp?id=' + card.id + '&cardtype=' + encodeURIComponent(card.cardtype) + '&cardholdername=' + encodeURIComponent(card.cardholdername) + '&cardnumber=' + card.cardnumber + '&expmonth=' + encodeURIComponent(card.expmonth) + '&expyear=' + encodeURIComponent(card.expyear) + '&cvn=' + card.cvn + '&amount=' + card.amount + '">' +
                                '<button>Update</button>' +
                            '</a> ' +
                            '<button onclick="deletePayment(' + card.id + ')">Delete</button>' +
                        '</td>';
                    tbody.appendChild(row);
                });
                
                document.getElementById('loadingMessage').style.display = 'none';
                document.getElementById('paymentTable').style.display = 'table';
            } else {
                document.getElementById('loadingMessage').textContent = 'Failed to load payments.';
            }
        } catch (error) {
            document.getElementById('loadingMessage').textContent = 'Error loading payments.';
        }
    }

    async function deletePayment(id) {
        if (!confirm('Are you sure you want to delete this payment record?')) {
            return;
        }
        
        try {
            const response = await fetch(contextPath + '/api/payment/delete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                credentials: 'include',
                body: 'id=' + id
            });
            
            const data = await response.json();
            
            if (data.status === 'success') {
                alert(data.message);
                loadPayments(); // Reload the table
            } else {
                alert(data.message);
            }
        } catch (error) {
            alert('Failed to delete payment. Please try again.');
        }
    }

    function filterTable(){
        var input, filter, table, tr, td, i, j, txtValue;
        input = document.getElementById("searchInput");
        filter = input.value.toUpperCase();
        table = document.getElementById("paymentTable");
        tr = table.getElementsByTagName("tr");
        
        for(i = 1; i < tr.length; i++) {
            tr[i].style.display = "none";
            
            td = tr[i].getElementsByTagName("td");
            for(j = 0; j < td.length; j++) {
                if (td[j]) {
                    txtValue = td[j].textContent || td[j].innerText;
                    if (txtValue.toUpperCase().indexOf(filter) > -1){
                        tr[i].style.display = "";	
                        break;
                    }	
                }
            }
        }
    }
</script>



</body>
</html>
