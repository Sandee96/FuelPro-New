package com.api;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.DAO.UserDao;
import com.connection.DBConnect;
import com.google.gson.Gson;
import com.model.UserModel;

@WebServlet("/api/auth/login")
public class AuthAPI extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Gson gson = new Gson();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            Connection connection = DBConnect.getConnection();
            UserDao userDao = new UserDao(connection);
            UserModel user = userDao.loginUser(email, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                session.setAttribute("username", user.getEmail());
                
                // Return JSON response
                ApiResponse<UserModel> apiResponse = new ApiResponse<>("success", "Login successful", user);
                out.print(gson.toJson(apiResponse));
            } else {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                ApiResponse<Object> apiResponse = new ApiResponse<>("error", "Invalid email or password", null);
                out.print(gson.toJson(apiResponse));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            e.printStackTrace();
            ApiResponse<Object> apiResponse = new ApiResponse<>("error", "Server error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        }
        out.flush();
    }

    // Inner class for API response structure
    public static class ApiResponse<T> {
        private String status;
        private String message;
        private T data;

        public ApiResponse(String status, String message, T data) {
            this.status = status;
            this.message = message;
            this.data = data;
        }

        public String getStatus() { return status; }
        public String getMessage() { return message; }
        public T getData() { return data; }
    }
}

