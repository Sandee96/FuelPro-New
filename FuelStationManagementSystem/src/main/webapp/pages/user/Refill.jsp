<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Refill Fuel</title>
    <link rel="stylesheet" href="../../assets/css/Refill.css">
    <style>
        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
            width: 240px;
            background: #111; /* match header/footer tone */
            color: #fff;
            padding: 24px 18px;
            box-shadow: 2px 0 8px rgba(0, 0, 0, 0.2);
            display: flex;
            flex-direction: column;
            gap: 14px;
            box-sizing: border-box;
            z-index: 1001;
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
</head>
<body>

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
    <div class="container">
        <h1>Fuel Up From Here </h1>
        <form id="refillForm" onsubmit="handleRefill(event)">
            <button type="button" onclick="findNearbyStations()" class="nearby-btn">
                📍 Find Nearby Gas Stations
            </button>
            <div id="locationMessage" style="display:none; margin: 10px 0; padding: 8px; border-radius: 4px;"></div>
            
            <label for="FuelStation">Select Fuel Station:</label>
            <div style="position: relative;">
                <input type="text" id="FuelStation" name="FuelStation" 
                       placeholder="Search for gas stations..." 
                       autocomplete="off" required>
                <div id="autocomplete-results" class="autocomplete-dropdown"></div>
            </div>
            <input type="hidden" id="stationPlaceId" name="stationPlaceId">
            <input type="hidden" id="stationLocation" name="stationLocation">
            
            <label for="FuelType">Select Fuel Type:</label>
            <select id="FuelType" name="FuelType" required>
                <option value="">--Select Fuel Type--</option>
                <option value="Petrol">Petrol</option>
                <option value="Diesel">Diesel</option>
                <option value="CNG">CNG</option>
                <option value="Electric">Electric</option>
                <option value="Hybrid">Hybrid</option>
            </select>
            
            <label for="amount">Enter Amount (In Dollars):</label>
            <input type="number" id="amount" name="amount" min="1" required>
            
            <input type="submit" value="Submit">
        </form>
        <div id="refillMessage" style="display:none; margin-top: 20px; padding: 10px; border-radius: 5px;"></div>
    </div>
    </div>
    <script>
        let selectedStation = null;
        let lastNearbyStations = [];
        const contextPath = '<%= request.getContextPath() %>';
        let autocompleteTimeout = null;

        // Autocomplete functionality
        document.getElementById('FuelStation').addEventListener('input', async function(e) {
            const input = e.target.value;
            
            // Clear previous timeout
            if (autocompleteTimeout) {
                clearTimeout(autocompleteTimeout);
            }
            
            if (input.length < 3) {
                document.getElementById('autocomplete-results').style.display = 'none';
                return;
            }
            
            // Debounce the API call
            autocompleteTimeout = setTimeout(async () => {
                try {
                    const response = await fetch(
                        contextPath + '/api/googlemaps/autocomplete?input=' + encodeURIComponent(input) + '&type=gas_station'
                    );
                    const data = await response.json();
                    
                    if (data.status === 'success' && data.data && data.data.predictions) {
                        showAutocompleteResults(data.data.predictions);
                    } else {
                        document.getElementById('autocomplete-results').style.display = 'none';
                    }
                } catch (error) {
                    console.error('Autocomplete error:', error);
                    document.getElementById('autocomplete-results').style.display = 'none';
                }
            }, 300); // 300ms debounce
        });

        function showAutocompleteResults(predictions) {
            const resultsDiv = document.getElementById('autocomplete-results');
            resultsDiv.innerHTML = '';
            
            if (predictions.length === 0) {
                resultsDiv.style.display = 'none';
                return;
            }
            
            predictions.forEach(prediction => {
                const div = document.createElement('div');
                div.className = 'autocomplete-item';
                div.innerHTML = '<strong>' + prediction.structured_formatting.main_text + '</strong><br>' +
                    '<small>' + prediction.structured_formatting.secondary_text + '</small>';
                div.onclick = () => selectStation(prediction);
                resultsDiv.appendChild(div);
            });
            
            resultsDiv.style.display = 'block';
        }

        function selectStation(prediction) {
            document.getElementById('FuelStation').value = prediction.structured_formatting.main_text;
            document.getElementById('stationPlaceId').value = prediction.place_id;
            document.getElementById('autocomplete-results').style.display = 'none';
            selectedStation = prediction;
        }

        // Find nearby stations using geolocation
        async function findNearbyStations() {
            const messageDiv = document.getElementById('locationMessage');
            
            // If we already have cached nearby stations, just re-show them without new API calls
            if (lastNearbyStations.length > 0) {
                showNearbyStations(lastNearbyStations);
                messageDiv.style.display = 'block';
                messageDiv.textContent = 'Showing previously found nearby stations';
                messageDiv.style.backgroundColor = '#d4edda';
                messageDiv.style.color = '#155724';
                return;
            }
            
            if (!navigator.geolocation) {
                showMessage('Geolocation is not supported by your browser', 'error');
                return;
            }
            
            messageDiv.style.display = 'block';
            messageDiv.textContent = 'Getting your location...';
            messageDiv.style.backgroundColor = '#d1ecf1';
            messageDiv.style.color = '#0c5460';
            
            navigator.geolocation.getCurrentPosition(async (position) => {
                const lat = position.coords.latitude;
                const lng = position.coords.longitude;
                const location = lat + ',' + lng;
                
                try {
                    const response = await fetch(
                        contextPath + '/api/googlemaps/nearbysearch?location=' + location + '&radius=5000&type=gas_station'
                    );
                    const data = await response.json();
                    
                    if (data.status === 'success' && data.data && data.data.results) {
                        showNearbyStations(data.data.results);
                        messageDiv.textContent = 'Found ' + data.data.results.length + ' nearby stations';
                        messageDiv.style.backgroundColor = '#d4edda';
                        messageDiv.style.color = '#155724';
                    } else {
                        showMessage('No stations found nearby', 'error');
                    }
                } catch (error) {
                    console.error('Nearby search error:', error);
                    showMessage('Failed to fetch nearby stations', 'error');
                }
            }, (error) => {
                let errorMsg = 'Unable to get your location';
                switch(error.code) {
                    case error.PERMISSION_DENIED:
                        errorMsg = 'Location access denied. Please enable location permissions.';
                        break;
                    case error.POSITION_UNAVAILABLE:
                        errorMsg = 'Location information unavailable.';
                        break;
                    case error.TIMEOUT:
                        errorMsg = 'Location request timed out.';
                        break;
                }
                showMessage(errorMsg, 'error');
            });
        }

        function showNearbyStations(stations) {
            const resultsDiv = document.getElementById('autocomplete-results');
            resultsDiv.innerHTML = '<div class="autocomplete-header">Nearby Gas Stations</div>';
            
            // Cache the most recent nearby stations so the user can reopen the list later
            lastNearbyStations = stations.slice(0, 10);

            lastNearbyStations.forEach(station => {
                const div = document.createElement('div');
                div.className = 'autocomplete-item';
                const distance = station.vicinity || station.formatted_address || '';
                div.innerHTML = '<strong>' + station.name + '</strong><br>' +
                    '<small>' + distance + '</small>';
                div.onclick = () => {
                    document.getElementById('FuelStation').value = station.name;
                    document.getElementById('stationPlaceId').value = station.place_id || '';
                    if (station.geometry && station.geometry.location) {
                        document.getElementById('stationLocation').value = 
                            station.geometry.location.lat + ',' + station.geometry.location.lng;
                    }
                    resultsDiv.style.display = 'none';
                    selectedStation = station;
                };
                resultsDiv.appendChild(div);
            });
            
            resultsDiv.style.display = 'block';
        }

        // When the input gains focus, re-show the last nearby results if available
        document.getElementById('FuelStation').addEventListener('focus', () => {
            const resultsDiv = document.getElementById('autocomplete-results');
            if (lastNearbyStations.length > 0) {
                showNearbyStations(lastNearbyStations);
                resultsDiv.style.display = 'block';
            }
        });

        function showMessage(message, type) {
            const messageDiv = document.getElementById('locationMessage');
            messageDiv.style.display = 'block';
            messageDiv.textContent = message;
            if (type === 'error') {
                messageDiv.style.backgroundColor = '#f8d7da';
                messageDiv.style.color = '#721c24';
            }
        }

        // Hide dropdown when clicking outside
        document.addEventListener('click', function(e) {
            if (!e.target.closest('#FuelStation') && !e.target.closest('#autocomplete-results')) {
                document.getElementById('autocomplete-results').style.display = 'none';
            }
        });

        // Keep existing handleRefill function
        async function handleRefill(event) {
            event.preventDefault();
            const formData = new FormData(event.target);
            
            try {
                const response = await fetch(contextPath + '/api/refill/', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: new URLSearchParams(formData)
                });
                
                const data = await response.json();
                console.log('API Response:', data); // Debug log
                const messageDiv = document.getElementById('refillMessage');
                
                if (data.status === 'success') {
                    messageDiv.style.display = 'block';
                    messageDiv.style.backgroundColor = '#d4edda';
                    messageDiv.style.color = '#155724';
                    const totalPrice = data.data && data.data.totalPrice ? parseFloat(data.data.totalPrice) : 0;
                    console.log('Total Price:', totalPrice); // Debug log
                    messageDiv.textContent = 'Refill request created! Total Price: $' + totalPrice.toFixed(2);
                    setTimeout(() => {
                        window.location.href = contextPath + '/pages/user/RefillDetails.jsp?FuelStation=' + encodeURIComponent(data.data.fuelStation) + '&FuelType=' + encodeURIComponent(data.data.fuelType) + '&amount=' + encodeURIComponent(data.data.amount) + '&TotalPrice=' + encodeURIComponent(totalPrice.toFixed(2));
                    }, 1500);
                } else {
                    messageDiv.style.display = 'block';
                    messageDiv.style.backgroundColor = '#f8d7da';
                    messageDiv.style.color = '#721c24';
                    messageDiv.textContent = data.message;
                }
            } catch (error) {
                const messageDiv = document.getElementById('refillMessage');
                messageDiv.style.display = 'block';
                messageDiv.style.backgroundColor = '#f8d7da';
                messageDiv.style.color = '#721c24';
                messageDiv.textContent = 'Refill request failed. Please try again.';
            }
        }
    </script>

</body>
</html>
