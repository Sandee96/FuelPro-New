package com.api;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import PaymentPackage.CardController;

@WebServlet("/api/payment/*")
public class PaymentAPI extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Gson gson = new Gson();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Get all payments
            handleGetAllPayments(request, response, out);
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Endpoint not found", null);
            out.print(gson.toJson(apiResponse));
        }
        out.flush();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Create payment
            handlePayment(request, response, out);
        } else if (pathInfo.equals("/update")) {
            // Update payment
            handleUpdatePayment(request, response, out);
        } else if (pathInfo.equals("/delete")) {
            // Delete payment
            handleDeletePayment(request, response, out);
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Endpoint not found", null);
            out.print(gson.toJson(apiResponse));
        }
        out.flush();
    }

    private void handleGetAllPayments(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        javax.servlet.http.HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Admin authentication required", null);
            out.print(gson.toJson(apiResponse));
            return;
        }

        try {
            java.util.List<PaymentPackage.CardModel> allCards = PaymentPackage.CardController.getAllCard();
            AuthAPI.ApiResponse<java.util.List<PaymentPackage.CardModel>> apiResponse = new AuthAPI.ApiResponse<>("success", "Payments retrieved successfully", allCards);
            out.print(gson.toJson(apiResponse));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        }
    }

    private void handlePayment(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        try {
            String cardtype = request.getParameter("cardtype");
            String cardholdername = request.getParameter("cardholdername");
            String cardnumberStr = request.getParameter("cardnumber");
            String expmonth = request.getParameter("expmonth");
            String expyear = request.getParameter("expyear");
            String cvnStr = request.getParameter("cvn");
            String amountStr = request.getParameter("amount");

            // Remove spaces and non-numeric characters before parsing
            String cardnumberClean = cardnumberStr.replaceAll("[^0-9]", "");
            String cvnClean = cvnStr.replaceAll("[^0-9]", "");
            String amountClean = amountStr.replaceAll("[^0-9]", "");

            int cardnumber = Integer.parseInt(cardnumberClean);
            int cvn = Integer.parseInt(cvnClean);
            int amount = Integer.parseInt(amountClean);

            boolean isTrue = CardController.insertdata(cardtype, cardholdername, cardnumber, expmonth, expyear, cvn, amount);

            if (isTrue) {
                AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("success", "Payment successful!", null);
                out.print(gson.toJson(apiResponse));
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Payment failed", null);
                out.print(gson.toJson(apiResponse));
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Invalid card number, CVN or amount format", null);
            out.print(gson.toJson(apiResponse));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        }
    }

    private void handleUpdatePayment(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        javax.servlet.http.HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Admin authentication required", null);
            out.print(gson.toJson(apiResponse));
            return;
        }

        try {
            String idStr = request.getParameter("id");
            String cardtype = request.getParameter("cardtype");
            String cardholdername = request.getParameter("cardholdername");
            String cardnumberStr = request.getParameter("cardnumber");
            String expmonth = request.getParameter("expmonth");
            String expyear = request.getParameter("expyear");
            String cvnStr = request.getParameter("cvn");
            String amountStr = request.getParameter("amount");

            // Remove spaces and non-numeric characters before parsing
            String cardnumberClean = cardnumberStr.replaceAll("[^0-9]", "");
            String cvnClean = cvnStr.replaceAll("[^0-9]", "");
            String amountClean = amountStr.replaceAll("[^0-9]", "");

            int id = Integer.parseInt(idStr);
            int cardnumber = Integer.parseInt(cardnumberClean);
            int cvn = Integer.parseInt(cvnClean);
            int amount = Integer.parseInt(amountClean);

            boolean isTrue = CardController.update(id, cardtype, cardholdername, cardnumber, expmonth, expyear, cvn, amount);

            if (isTrue) {
                AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("success", "Payment updated successfully", null);
                out.print(gson.toJson(apiResponse));
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Failed to update payment", null);
                out.print(gson.toJson(apiResponse));
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Invalid card number, CVN or amount format", null);
            out.print(gson.toJson(apiResponse));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        }
    }

    private void handleDeletePayment(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        javax.servlet.http.HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Admin authentication required", null);
            out.print(gson.toJson(apiResponse));
            return;
        }

        try {
            String id = request.getParameter("id");
            boolean isTrue = CardController.deletedata(id);

            if (isTrue) {
                AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("success", "Payment deleted successfully", null);
                out.print(gson.toJson(apiResponse));
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Failed to delete payment", null);
                out.print(gson.toJson(apiResponse));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        }
    }
}

