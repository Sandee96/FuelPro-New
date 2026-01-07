package com.api;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import RefillCtrl.Refill;
import RefillCtrl.RefillDBUtil;

@WebServlet("/api/refill/*")
public class RefillAPI extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Gson gson = new Gson();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Create refill request
            handleRefill(request, response, out);
        } else if (pathInfo.equals("/delete")) {
            // Delete refill
            handleDeleteRefill(request, response, out);
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Endpoint not found", null);
            out.print(gson.toJson(apiResponse));
        }
        out.flush();
    }

    private void handleRefill(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        try {
            String FuelStation = request.getParameter("FuelStation");
            String FuelType = request.getParameter("FuelType");
            String Amount = request.getParameter("amount");

            Refill RefillReq = new Refill();
            RefillReq.setFuelStation(FuelStation);
            RefillReq.setFuelType(FuelType);
            RefillReq.setAmount(Integer.parseInt(Amount));

            RefillDBUtil.UpdateRefilRecord(RefillReq);
            double TotalPrice = RefillDBUtil.CalculatePrice(Integer.parseInt(Amount), FuelType);

            RefillData refillData = new RefillData(FuelStation, FuelType, Integer.parseInt(Amount), TotalPrice);
            AuthAPI.ApiResponse<RefillData> apiResponse = new AuthAPI.ApiResponse<>("success", "Refill request created successfully", refillData);
            out.print(gson.toJson(apiResponse));
        } catch (ClassNotFoundException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Database error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        }
    }

    private void handleDeleteRefill(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        try {
            String FuelStation = request.getParameter("FuelStation");
            String FuelType = request.getParameter("FuelType");
            String Amount = request.getParameter("amount");

            Refill RefillReq = new Refill();
            RefillReq.setFuelStation(FuelStation);
            RefillReq.setFuelType(FuelType);
            RefillReq.setAmount(Integer.parseInt(Amount));

            RefillDBUtil.DeleteRecord(RefillReq);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("success", "Record deleted successfully", null);
            out.print(gson.toJson(apiResponse));
        } catch (ClassNotFoundException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Database error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        }
    }

    public static class RefillData {
        private String fuelStation;
        private String fuelType;
        private int amount;
        private double totalPrice;

        public RefillData(String fuelStation, String fuelType, int amount, double totalPrice) {
            this.fuelStation = fuelStation;
            this.fuelType = fuelType;
            this.amount = amount;
            this.totalPrice = totalPrice;
        }

        public String getFuelStation() { return fuelStation; }
        public String getFuelType() { return fuelType; }
        public int getAmount() { return amount; }
        public double getTotalPrice() { return totalPrice; }
    }
}

