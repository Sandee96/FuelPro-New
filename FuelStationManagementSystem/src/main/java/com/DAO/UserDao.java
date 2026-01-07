package com.DAO;

import com.model.UserModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDao {

    private Connection DBConnect;

    // Constructor to initialize the database connection
    public UserDao(Connection DBConnect) {
        this.DBConnect = DBConnect;
    }

    // Register a new user with raw password and integer status
    public boolean registerUser(UserModel user) {
        String query = "INSERT INTO user (firstName, lastName, email, mobile, status, password) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = DBConnect.prepareStatement(query)) {
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getMobile());
            ps.setInt(5, user.getStatus());  // Status is now an integer
            ps.setString(6, user.getPassword()); // Save the raw password

            int result = ps.executeUpdate();
            return result > 0;  // If a row was inserted, return true

        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;  // If an error occurs or no rows were inserted, return false
    }

    // Login validation (check if user exists with given email and password)
    public UserModel loginUser(String email, String password) {
        String query = "SELECT * FROM user WHERE email = ? AND password = ?";
        try (PreparedStatement ps = DBConnect.prepareStatement(query)) {
            ps.setString(1, email);
            ps.setString(2, password); // Use raw password for login check

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // Get user data
                UserModel user = new UserModel();
                user.setUserId(rs.getInt("userId"));
                user.setFirstName(rs.getString("firstName"));
                user.setLastName(rs.getString("lastName"));
                user.setEmail(rs.getString("email"));
                user.setMobile(rs.getString("mobile"));
                user.setStatus(rs.getInt("status"));  // Status is now an integer
                user.setPassword(rs.getString("password")); // Raw password is fetched

                return user;  // Return the found user
            }

        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;  // Return null if no user is found or password doesn't match
    }

    // Update user details, including raw password and integer status
    public boolean updateUser(UserModel user) {
        String query = "UPDATE user SET firstName = ?, lastName = ?, email = ?, mobile = ? WHERE userId = ?";
        try (PreparedStatement ps = DBConnect.prepareStatement(query)) {
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getMobile());
            ps.setInt(5, user.getUserId());

            int result = ps.executeUpdate();
            return result > 0;  // If the row was updated, return true

        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;  // Return false if no rows were updated
    }

    // Fetch user details by userId
    public UserModel getUserById(int userId) {
        String query = "SELECT * FROM user WHERE userId = ?";
        try (PreparedStatement ps = DBConnect.prepareStatement(query)) {
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                UserModel user = new UserModel();
                user.setUserId(rs.getInt("userId"));
                user.setFirstName(rs.getString("firstName"));
                user.setLastName(rs.getString("lastName"));
                user.setEmail(rs.getString("email"));
                user.setMobile(rs.getString("mobile"));
                user.setStatus(rs.getInt("status"));  // Status is now an integer
                user.setPassword(rs.getString("password")); // Raw password is fetched
                return user;  // Return the found user
            }

        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;  // Return null if no user is found
    }

 // Update user password
    public boolean verifyUserPassword(int userId, String newPassword) {
        String query = "UPDATE user SET password = ? WHERE userId = ?";
        try (PreparedStatement ps = DBConnect.prepareStatement(query)) {
            ps.setString(1, newPassword); // Set the new raw password
            ps.setInt(2, userId); // Set the userId for the update

            int result = ps.executeUpdate();
            return result > 0; // Return true if the row was updated
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false; // Return false if no rows were updated
    }
    
    public boolean deleteUser(int userId) {
        String query = "DELETE FROM user WHERE userId = ?";
        try (PreparedStatement ps = DBConnect.prepareStatement(query)) {
            ps.setInt(1, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // Return true if the deletion was successful
        } catch (SQLException ex) {
            Logger.getLogger(UserDao.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false; // Return false if an error occurred
    }


}
