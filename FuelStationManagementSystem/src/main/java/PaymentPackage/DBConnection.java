package PaymentPackage;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

	private static String url ="jdbc:mysql://localhost:3306/online_vehicle_fuelstation_management_system";
	private static String user ="root";
	private static String pass ="password";
	private static Connection con;
	
	public static Connection getConnection() {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection(url, user, pass);
			
		}catch(Exception e){
			System.out.println("DB not connected");
		}
		return con;
	}
	
	
	
}