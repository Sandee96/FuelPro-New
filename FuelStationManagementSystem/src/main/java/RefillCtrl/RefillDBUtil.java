package RefillCtrl;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RefillDBUtil {
	
	
	public static int UpdateRefilRecord(Refill RefillReq) throws ClassNotFoundException {
		
		String URL = "jdbc:mysql://localhost:3306/online_vehicle_fuelstation_management_system";
		String UserName = "root";
		String PW = "password";
		int result = 0;
		
		try {
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection Con = DriverManager.getConnection(URL,UserName,PW);
			String InsertQuery = "INSERT INTO refill(FuelStation,FuelType,Amount) VALUES (?,?,?) ";
			PreparedStatement pstmt = Con.prepareStatement(InsertQuery);
			
			 pstmt.setString(1, RefillReq.getFuelStation());
			 pstmt.setString(2, RefillReq.getFuelType());
			 pstmt.setInt(3, RefillReq.getAmount());
			 
			 System.out.println(pstmt);
		        
		     result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		
		return result;
		
	}
	
	public static double DeleteRecord(Refill RefillReq) throws ClassNotFoundException {
		
		String URL = "jdbc:mysql://localhost:3306/online_vehicle_fuelstation_management_system";
		String UserName = "root";
		String PW = "password";
		int result = 0;
		
		try {
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection Con = DriverManager.getConnection(URL,UserName,PW);
			String RecToDel = "DELETE FROM refill WHERE FuelStation = ? AND FuelType = ? AND Amount = ?";
			PreparedStatement pstmt = Con.prepareStatement(RecToDel);
			
			 pstmt.setString(1, RefillReq.getFuelStation());
			 pstmt.setString(2, RefillReq.getFuelType());
			 pstmt.setInt(3, RefillReq.getAmount());
			 
			 System.out.println(pstmt);
		        
		     result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		
		return result;
		
		
	}
	
	public static double CalculatePrice(int Amount, String FuelType) throws ClassNotFoundException {
	    String URL = "jdbc:mysql://localhost:3306/online_vehicle_fuelstation_management_system";
	    String UserName = "root";
	    String PW = "password";
	    double TotalPrice = 0;

	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        Connection Con = DriverManager.getConnection(URL, UserName, PW);
	        String UnitPr = "SELECT UnitPr FROM fueltype WHERE FuelTypeName = ?";
	        PreparedStatement pstmt = Con.prepareStatement(UnitPr);

	        pstmt.setString(1, FuelType);  // Use the provided FuelType parameter

	        ResultSet rs = pstmt.executeQuery();

	        if (rs.next()) {
	            double unitPrice = rs.getDouble("UnitPr");
	            TotalPrice = new Refill().CalPay(unitPrice, Amount); // Create a new instance for calculation
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return TotalPrice;
	}

		
	}
	
		
	

