package Customer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class CustomerController {
	private static boolean isSuccess;
	private static Connection con = null;
	private static Statement stmt = null;
	private static ResultSet rs = null;
	
	//Insert Data Function
	public static boolean insertdata(String vehiclenumber, String servicetype, String servicestation, String date, String time) {
		
		boolean isSuccess = false;
		try {
			
			con=CustomerDBConnection.getConnection();
			
			// Use PreparedStatement with explicit column names to allow created_at to use default value
			String sql = "INSERT INTO service(vehiclenumber,servicetype,servicestation,date,time) VALUES (?,?,?,?,?)";
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, vehiclenumber);
			ps.setString(2, servicetype);
			ps.setString(3, servicestation);
			ps.setString(4, date);
			ps.setString(5, time);
			
			int rs = ps.executeUpdate();
			if(rs>0) {
				isSuccess = true;
			}
			else {
				isSuccess = false;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return isSuccess;

}
}
