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

@WebServlet("/api/user/*")
public class UserAPI extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Gson gson = new Gson();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Register user
            handleRegister(request, response, out);
        } else if (pathInfo.equals("/update")) {
            // Update profile
            handleUpdateProfile(request, response, out);
        } else if (pathInfo.equals("/delete")) {
            // Delete user
            handleDeleteUser(request, response, out);
        } else if (pathInfo.equals("/changepassword")) {
            // Change password
            handleChangePassword(request, response, out);
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Endpoint not found", null);
            out.print(gson.toJson(apiResponse));
        }
        out.flush();
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String password = request.getParameter("password");
        int status = 1;

        UserModel user = new UserModel();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setMobile(mobile);
        user.setPassword(password);
        user.setStatus(status);

        Connection connection = DBConnect.getConnection();
        UserDao userDao = new UserDao(connection);
        boolean isRegistered = userDao.registerUser(user);

        if (isRegistered) {
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("success", "Registration successful! You can now log in.", null);
            out.print(gson.toJson(apiResponse));
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Registration failed. Please try again.", null);
            out.print(gson.toJson(apiResponse));
        }
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        HttpSession session = request.getSession();
        UserModel currentUser = (UserModel) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "You need to be logged in.", null);
            out.print(gson.toJson(apiResponse));
            return;
        }

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String mobile = request.getParameter("mobile");

            UserModel user = new UserModel();
            user.setUserId(userId);
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setMobile(mobile);
            user.setPassword(currentUser.getPassword()); // Keep existing password
            user.setStatus(currentUser.getStatus());

            Connection connection = DBConnect.getConnection();
            UserDao userDao = new UserDao(connection);
            boolean isUpdated = userDao.updateUser(user);

            if (isUpdated) {
                session.setAttribute("currentUser", user);
                AuthAPI.ApiResponse<UserModel> apiResponse = new AuthAPI.ApiResponse<>("success", "Profile updated successfully.", user);
                out.print(gson.toJson(apiResponse));
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Failed to update profile.", null);
                out.print(gson.toJson(apiResponse));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        }
    }

    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        HttpSession session = request.getSession();
        UserModel currentUser = (UserModel) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "You need to be logged in.", null);
            out.print(gson.toJson(apiResponse));
            return;
        }

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            Connection connection = DBConnect.getConnection();
            UserDao userDao = new UserDao(connection);
            boolean isDeleted = userDao.deleteUser(userId);

            if (isDeleted) {
                session.invalidate();
                AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("success", "Account deleted successfully.", null);
                out.print(gson.toJson(apiResponse));
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Failed to delete account.", null);
                out.print(gson.toJson(apiResponse));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Error: " + e.getMessage(), null);
            out.print(gson.toJson(apiResponse));
        }
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        HttpSession session = request.getSession();
        UserModel currentUser = (UserModel) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "You need to be logged in.", null);
            out.print(gson.toJson(apiResponse));
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentUser.getPassword().equals(currentPassword)) {
            if (newPassword.equals(confirmPassword)) {
                Connection connection = DBConnect.getConnection();
                UserDao userDao = new UserDao(connection);
                boolean isUpdated = userDao.verifyUserPassword(currentUser.getUserId(), newPassword);

                if (isUpdated) {
                    currentUser.setPassword(newPassword);
                    session.setAttribute("currentUser", currentUser);
                    AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("success", "Password changed successfully.", null);
                    out.print(gson.toJson(apiResponse));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Failed to change password.", null);
                    out.print(gson.toJson(apiResponse));
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "New passwords do not match.", null);
                out.print(gson.toJson(apiResponse));
            }
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            AuthAPI.ApiResponse<Object> apiResponse = new AuthAPI.ApiResponse<>("error", "Current password is incorrect.", null);
            out.print(gson.toJson(apiResponse));
        }
    }
}

