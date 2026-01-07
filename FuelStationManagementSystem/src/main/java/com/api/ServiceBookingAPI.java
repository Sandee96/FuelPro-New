package com.api;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import Customer.CustomerController;

@WebServlet("/api/service/booking")
public class ServiceBookingAPI extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Gson gson = new Gson();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String vehiclenumber = request.getParameter("vehiclenumber");
        String servicetype = request.getParameter("servicetype");
        String servicestation = request.getParameter("servicestation");
        String date = request.getParameter("date");
        String time = request.getParameter("time");

        boolean isTrue = CustomerController.insertdata(vehiclenumber, servicetype, servicestation, date, time);

        if (isTrue) {
            BookingData bookingData = new BookingData(vehiclenumber, servicetype, servicestation, date, time);
            AuthAPI.ApiResponse<BookingData> apiResponse = new AuthAPI.ApiResponse<>("success", "Booking created successfully", bookingData);
            out.print(gson.toJson(apiResponse));
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Booking failed", null);
            out.print(gson.toJson(apiResponse));
        }
        out.flush();
    }

    public static class BookingData {
        private String vehiclenumber;
        private String servicetype;
        private String servicestation;
        private String date;
        private String time;

        public BookingData(String vehiclenumber, String servicetype, String servicestation, String date, String time) {
            this.vehiclenumber = vehiclenumber;
            this.servicetype = servicetype;
            this.servicestation = servicestation;
            this.date = date;
            this.time = time;
        }

        public String getVehiclenumber() { return vehiclenumber; }
        public String getServicetype() { return servicetype; }
        public String getServicestation() { return servicestation; }
        public String getDate() { return date; }
        public String getTime() { return time; }
    }
}

