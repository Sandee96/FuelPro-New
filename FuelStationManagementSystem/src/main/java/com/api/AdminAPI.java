package com.api;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import AdminPackage.OvmsDAO;
import AdminPackage.Service;

@WebServlet("/api/admin/*")
public class AdminAPI extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Gson gson = new Gson();
    private OvmsDAO dao = new OvmsDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Get all services
            handleGetAllServices(request, response, out);
        } else if (pathInfo.startsWith("/service/")) {
            String serviceId = pathInfo.substring("/service/".length());
            if (!serviceId.isEmpty()) {
                // Get single service by ID
                handleGetService(request, response, out, Integer.parseInt(serviceId));
            }
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
            // Login
            handleLogin(request, response, out);
        } else if (pathInfo.equals("/service")) {
            // Create service
            handleCreateService(request, response, out);
        } else if (pathInfo.equals("/service/update")) {
            // Update service
            handleUpdateService(request, response, out);
        } else if (pathInfo.equals("/service/delete")) {
            // Delete service
            handleDeleteService(request, response, out);
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Endpoint not found", null);
            out.print(gson.toJson(apiResponse));
        }
        out.flush();
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Username and password required", null);
            out.print(gson.toJson(apiResponse));
            return;
        }

        try {
            boolean isValid = dao.adminCheck(username, password);
            if (isValid) {
                HttpSession session = request.getSession();
                session.setAttribute("admin", username);
                AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("success", "Login successful", null);
                out.print(gson.toJson(apiResponse));
            } else {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Invalid credentials", null);
                out.print(gson.toJson(apiResponse));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        }
    }

    private void handleGetAllServices(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Admin authentication required", null);
            out.print(gson.toJson(apiResponse));
            return;
        }

        try {
            List<Service> services = dao.getAllServices();
            AuthAPI.ApiResponse<List<Service>> apiResponse = new AuthAPI.ApiResponse<>("success", "Services retrieved successfully", services);
            out.print(gson.toJson(apiResponse));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        }
    }

    private void handleGetService(HttpServletRequest request, HttpServletResponse response, PrintWriter out, int id) {
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Admin authentication required", null);
            out.print(gson.toJson(apiResponse));
            return;
        }

        try {
            Service service = dao.selectOldService(id);
            if (service != null) {
                AuthAPI.ApiResponse<Service> apiResponse = new AuthAPI.ApiResponse<>("success", "Service retrieved successfully", service);
                out.print(gson.toJson(apiResponse));
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Service not found", null);
                out.print(gson.toJson(apiResponse));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        }
    }

    private void handleCreateService(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Admin authentication required", null);
            out.print(gson.toJson(apiResponse));
            return;
        }

        try {
            String vehiclenumber = request.getParameter("vehiclenumber");
            String servicetype = request.getParameter("servicetype");
            String servicestation = request.getParameter("servicestation");
            String date = request.getParameter("date");
            String time = request.getParameter("time");

            Service service = new Service(vehiclenumber, servicetype, servicestation, date, time);
            dao.addNewService(service);
            
            AuthAPI.ApiResponse<Service> apiResponse = new AuthAPI.ApiResponse<>("success", "Service created successfully", service);
            out.print(gson.toJson(apiResponse));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        }
    }

    private void handleUpdateService(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Admin authentication required", null);
            out.print(gson.toJson(apiResponse));
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String vehiclenumber = request.getParameter("vehiclenumber");
            String servicetype = request.getParameter("servicetype");
            String servicestation = request.getParameter("servicestation");
            String date = request.getParameter("date");
            String time = request.getParameter("time");

            Service service = new Service(id, vehiclenumber, servicetype, servicestation, date, time);
            boolean isUpdated = dao.updateOldService(service);
            
            if (isUpdated) {
                AuthAPI.ApiResponse<Service> apiResponse = new AuthAPI.ApiResponse<>("success", "Service updated successfully", service);
                out.print(gson.toJson(apiResponse));
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Failed to update service", null);
                out.print(gson.toJson(apiResponse));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        }
    }

    private void handleDeleteService(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Admin authentication required", null);
            out.print(gson.toJson(apiResponse));
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteService(id);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("success", "Service deleted successfully", null);
            out.print(gson.toJson(apiResponse));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        }
    }
}

