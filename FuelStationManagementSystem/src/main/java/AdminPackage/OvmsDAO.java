package AdminPackage;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OvmsDAO {
	
	public Connection dbConnection() {
		Connection con = null;
		
		String url = "jdbc:mysql://localhost:3306/online_vehicle_fuelstation_management_system";
		String un = "root";
		String pw = "password";
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			
			con = DriverManager.getConnection(url,un,pw);
			
			System.out.println("Database connection success");
			
		} catch (Exception e) {
			System.err.println("Database connection failed: " + e.getMessage());
			e.printStackTrace();
		}
		return con;
	}

	public boolean adminCheck(String un, String up) {
		Connection con = dbConnection();
		
		if (con == null) {
			System.err.println("Database connection is null in adminCheck");
			return false;
		}
		
		try {
			String query= "SELECT * FROM admin WHERE username=? AND password=?";
			PreparedStatement  ps = con.prepareStatement(query);
			ps.setString(1, un);
			ps.setString(2, up);
			
			System.out.println("Executing query: " + query + " with username: " + un);
			
			ResultSet rs = ps.executeQuery();
			
			if(rs.next()) {
				System.out.println("Admin found in database");
				return true;
			} else {
				System.out.println("No admin found with these credentials");
			}
		}catch(Exception e) {
			System.err.println("Error in adminCheck: " + e.getMessage());
			e.printStackTrace();
		}
		return false;
	}

	public List<Service> getAllServices() {
		List<Service> relist = new ArrayList<>();
		Connection con = dbConnection();
		
		String query ="SELECT * FROM service ";
		
		try {
			PreparedStatement ps = con.prepareStatement(query);
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				int id = rs.getInt("id");
				String vehiclenumber = rs.getString("vehiclenumber");
				String servicetype = rs.getString("servicetype");
				String servicestation = rs.getString("servicestation");
				String date = rs.getString("date");
				String time = rs.getString("time");
				
				relist.add(new Service (id,vehiclenumber,servicetype,servicestation,date,time));
			}
		}catch(Exception e) {
			
		}
		
		return relist;
		
	}

	public void addNewService(Service se) {
		try {
			Connection con =dbConnection();
			String sql = "INSERT INTO service(vehiclenumber,servicetype,servicestation,date,time) VALUES (?,?,?,?,?)";
			
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1,se.getVehiclenumber());
			ps.setString(2, se.getServicetype());
			ps.setString(3, se.getServicestation());
			ps.setString(4, se.getDate());
			ps.setString(5, se.getTime());
			
			System.out.println(ps);
			ps.executeUpdate();
			
		}catch(Exception e) {
			
		}
		
	}

	public Service selectOldService(int id) {
		Connection con=dbConnection();
		
		Service oldService= null;
		
		try {
			String sql = "SELECT * FROM service WHERE id=?";
			PreparedStatement ps=con.prepareStatement(sql);
			ps.setInt(1, id);
			
			System.out.println(ps);
			
			ResultSet rs=ps.executeQuery();
			
			while(rs.next()) {
				String vehiclenumber=rs.getString("vehiclenumber");
				String servicetype=rs.getString("servicetype");
				String servicestation=rs.getString("servicestation");
				String date=rs.getString("date");
				String time=rs.getString("time");
				
				oldService=new Service(id,vehiclenumber,servicetype,servicestation,date,time);
			}
			
		}catch (Exception e) {
			
		}
		return oldService;
	}

	public boolean updateOldService(Service updatedService) {
		Connection con= dbConnection();
		boolean update=false;
		try {
			String sql="UPDATE service SET vehiclenumber=?,servicetype=?,servicestation=?,date=?,time=? WHERE id=?";
			PreparedStatement ps = con.prepareStatement(sql);
			
			
			ps.setString(1, updatedService.getVehiclenumber());
			ps.setString(2, updatedService.getServicetype());
			ps.setString(3, updatedService.getServicestation());
			ps.setString(4, updatedService.getDate());
			ps.setString(5, updatedService.getTime());
			
			ps.setInt(6, updatedService.getId());
			
			update = ps.executeUpdate() > 0;
				
		}catch(Exception e) {
			
		}
		return update;
	}

	public void deleteService(int id) {
		Connection con= dbConnection();
		
		try {
			String query ="DELETE FROM service WHERE id=?";
			PreparedStatement ps = con.prepareStatement(query);
			
			ps.setInt(1, id);
			ps.executeUpdate();
			
			System.out.println("Delete Successfull");
			
		}catch (Exception e) {
			
		}
		
	}

	

}
