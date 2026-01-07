package com.api;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import javax.net.ssl.HttpsURLConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.util.SSLUtil;

/**
 * Servlet to proxy Google Maps API requests through WSO2 API Manager.
 * This servlet acts as a backend proxy to hide WSO2 credentials from the frontend.
 */
@WebServlet("/api/googlemaps/*")
public class GoogleMapsProxyAPI extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // WSO2 API Manager base URL
    private static final String WSO2_BASE_URL = "https://localhost:8243/googlemaps/1.0.0";
    
    // OAuth 2.0 Bearer token from WSO2 Developer Portal
    // In production, this should be stored securely (e.g., environment variable, config file, etc.)
    private static final String WSO2_TOKEN = "eyJ4NXQiOiJNekF6TVRGak9EUTFNRE5qT1RVMVpEQTROR1E1TURrell6RTNNV0k0TW1SbFpHVTNZelpqWWprNFpHUmtNMlJoTW1Jd01qQXhZekpsTUdKak5qZG1OdyIsImtpZCI6Ik16QXpNVEZqT0RRMU1ETmpPVFUxWkRBNE5HUTVNRGt6WXpFM01XSTRNbVJsWkdVM1l6WmpZams0WkdSa00yUmhNbUl3TWpBeFl6SmxNR0pqTmpkbU53X1JTMjU2IiwidHlwIjoiYXQrand0IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJkMDllODMwMi1lOThkLTRiMGMtOWMxYi05MjI1YmJlY2FlNjAiLCJhdXQiOiJBUFBMSUNBVElPTiIsImF1ZCI6IlVzMktjUlZyNE1Qa01PV1hXbGZWVEgzNEU5a2EiLCJuYmYiOjE3NjU3NzU4ODksImF6cCI6IlVzMktjUlZyNE1Qa01PV1hXbGZWVEgzNEU5a2EiLCJzY29wZSI6ImRlZmF1bHQiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo5NDQzL29hdXRoMi90b2tlbiIsImV4cCI6MTc4MTU0Mzg4OSwiaWF0IjoxNzY1Nzc1ODg5LCJqdGkiOiIxOTY3YjRmNS1kZmRkLTRiZjctODE3Yi1lYzc3ZWM5ZDRhOGIiLCJjbGllbnRfaWQiOiJVczJLY1JWcjRNUGtNT1dYV2xmVlRIMzRFOWthIn0.HY2laFH0Nls-ddMqIJLnVYbXAeoML-HUNXtRIyCPYMYbFQIJ0XCH5Z-Mx3Evw0Es_wAW267lI4aVJGcKM07sKOI_o0VSgn4nAy37a8utX95_lY4TtjjTlUnDo7uB25zvqUvS3aB6-O8iSryzzN3MlSlBu_fI8jGh0Nc0YfO5GbZNPh9VBENXW9PM1MJvjR0-pX0KBN1AfMah_kGZumw9n1FiHFU5SixhLEXrHsAPdz438Vi_DPtkZlzavr5FYQ0ZpC3hpocfIhbAsoOFJL1aVwRcgqr_ZG-IlhhFbVu3B5AzG84v7KjZQTTx0KyWe967B4SslFnkRRfD8TVxUgWNlw";
    
    private Gson gson = new Gson();
    
    static {
        // Disable SSL verification for localhost development only
        SSLUtil.disableSSLVerification();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        
        PrintWriter out = response.getWriter();
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>(
                    "error", "Invalid endpoint. Use /autocomplete or /nearbysearch", null);
                out.print(gson.toJson(apiResponse));
            } else if ("/autocomplete".equals(pathInfo)) {
                handleAutocomplete(request, response, out);
            } else if ("/nearbysearch".equals(pathInfo)) {
                handleNearbySearch(request, response, out);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>(
                    "error", "Endpoint not found", null);
                out.print(gson.toJson(apiResponse));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            e.printStackTrace();
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>(
                "error", "Server error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        } finally {
            out.flush();
        }
    }
    
    /**
     * Handle autocomplete requests
     */
    private void handleAutocomplete(HttpServletRequest request, HttpServletResponse response, PrintWriter out) 
            throws IOException {
        
        String input = request.getParameter("input");
        if (input == null || input.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>(
                "error", "Input parameter is required", null);
            out.print(gson.toJson(apiResponse));
            return;
        }
        
        // Build WSO2 API URL
        StringBuilder wso2Url = new StringBuilder(WSO2_BASE_URL + "/place/autocomplete/json");
        wso2Url.append("?input=").append(URLEncoder.encode(input, "UTF-8"));
        
        // Add optional parameters
        String location = request.getParameter("location");
        if (location != null && !location.trim().isEmpty()) {
            wso2Url.append("&location=").append(URLEncoder.encode(location, "UTF-8"));
        }
        
        String radius = request.getParameter("radius");
        if (radius != null && !radius.trim().isEmpty()) {
            wso2Url.append("&radius=").append(URLEncoder.encode(radius, "UTF-8"));
        }
        
        String type = request.getParameter("type");
        if (type != null && !type.trim().isEmpty()) {
            wso2Url.append("&type=").append(URLEncoder.encode(type, "UTF-8"));
        }
        
        // Call WSO2 API
        String apiResponse = callWSO2API(wso2Url.toString());
        
        if (apiResponse != null) {
            // Parse the response to check for errors
            try {
                // Forward the Google Maps API response directly
                // Wrapping it in our ApiResponse structure for consistency
                Object responseData = gson.fromJson(apiResponse, Object.class);
                AuthAPI.ApiResponse<Object> wrappedResponse = new AuthAPI.ApiResponse<>(
                    "success", "Autocomplete results retrieved", responseData);
                out.print(gson.toJson(wrappedResponse));
            } catch (Exception e) {
                // If parsing fails, return raw response
                out.print(apiResponse);
            }
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            AuthAPI.ApiResponse<Object> apiResponseObj = new AuthAPI.ApiResponse<>(
                "error", "Failed to retrieve autocomplete results from WSO2 API", null);
            out.print(gson.toJson(apiResponseObj));
        }
    }
    
    /**
     * Handle nearby search requests
     */
    private void handleNearbySearch(HttpServletRequest request, HttpServletResponse response, PrintWriter out) 
            throws IOException {
        
        String location = request.getParameter("location");
        if (location == null || location.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>(
                "error", "Location parameter is required (format: lat,lng)", null);
            out.print(gson.toJson(apiResponse));
            return;
        }
        
        // Build WSO2 API URL
        StringBuilder wso2Url = new StringBuilder(WSO2_BASE_URL + "/place/nearbysearch/json");
        wso2Url.append("?location=").append(URLEncoder.encode(location, "UTF-8"));
        
        // Add optional parameters
        String radius = request.getParameter("radius");
        if (radius != null && !radius.trim().isEmpty()) {
            wso2Url.append("&radius=").append(URLEncoder.encode(radius, "UTF-8"));
        } else {
            // Default radius if not provided
            wso2Url.append("&radius=5000");
        }
        
        String type = request.getParameter("type");
        if (type != null && !type.trim().isEmpty()) {
            wso2Url.append("&type=").append(URLEncoder.encode(type, "UTF-8"));
        } else {
            // Default to gas_station if not provided
            wso2Url.append("&type=gas_station");
        }
        
        // Call WSO2 API
        String apiResponse = callWSO2API(wso2Url.toString());
        
        if (apiResponse != null) {
            // Parse the response to check for errors
            try {
                // Forward the Google Maps API response directly
                Object responseData = gson.fromJson(apiResponse, Object.class);
                AuthAPI.ApiResponse<Object> wrappedResponse = new AuthAPI.ApiResponse<>(
                    "success", "Nearby search results retrieved", responseData);
                out.print(gson.toJson(wrappedResponse));
            } catch (Exception e) {
                // If parsing fails, return raw response
                out.print(apiResponse);
            }
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            AuthAPI.ApiResponse<Object> apiResponseObj = new AuthAPI.ApiResponse<>(
                "error", "Failed to retrieve nearby search results from WSO2 API", null);
            out.print(gson.toJson(apiResponseObj));
        }
    }
    
    /**
     * Make HTTP GET request to WSO2 API with OAuth token
     */
    private String callWSO2API(String urlString) {
        HttpURLConnection connection = null;
        BufferedReader reader = null;
        
        try {
            URL url = new URL(urlString);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Authorization", "Bearer " + WSO2_TOKEN);
            connection.setRequestProperty("Accept", "application/json");
            connection.setConnectTimeout(10000); // 10 seconds
            connection.setReadTimeout(10000); // 10 seconds
            
            int responseCode = connection.getResponseCode();
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                StringBuilder response = new StringBuilder();
                String line;
                
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                
                return response.toString();
            } else {
                // Read error response
                reader = new BufferedReader(new InputStreamReader(connection.getErrorStream()));
                StringBuilder errorResponse = new StringBuilder();
                String line;
                
                while ((line = reader.readLine()) != null) {
                    errorResponse.append(line);
                }
                
                System.err.println("WSO2 API Error Response Code: " + responseCode);
                System.err.println("Error Response: " + errorResponse.toString());
                return null;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (connection != null) {
                connection.disconnect();
            }
        }
    }
}
