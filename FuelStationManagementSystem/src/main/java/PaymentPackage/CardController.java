package PaymentPackage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CardController {
	
	private static boolean isSuccess;
	private static Connection con = null;
	private static Statement stmt = null;
	private static ResultSet rs = null;
	
	// The method must return a boolean value
	public static boolean insertdata(String cardtype, String cardholdername, int cardnumber, String expmonth, String expyear, int cvn, int amount) {
		boolean isSuccess = false;
		try {
			con = DBConnection.getConnection();
			
			// Use PreparedStatement with explicit column names to allow created_at to use default value
			String sql = "INSERT INTO card(cardtype,cardholdername,cardnumber,expmonth,expyear,cvn,amount) VALUES (?,?,?,?,?,?,?)";
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, cardtype);
			ps.setString(2, cardholdername);
			ps.setInt(3, cardnumber);
			ps.setString(4, expmonth);
			ps.setString(5, expyear);
			ps.setInt(6, cvn);
			ps.setInt(7, amount);
			
			int rs = ps.executeUpdate();
			
			// Check if the query was successful
			if (rs > 0) {
				isSuccess = true;
			} else {
				isSuccess = false;
			}
			 
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// Return the success status
		return isSuccess;
	}
	

	
 //getById
public static List<CardModel> getById (String Id){
	int convertedID = Integer.parseInt(Id);
	ArrayList <CardModel> card = new ArrayList<>();
	
	try {
		//DBConnection
		 con = DBConnection.getConnection();
         stmt = con.createStatement();
         
         //Query
         String sql = "select * from card where id '"+convertedID+"'";
         
         rs = stmt.executeQuery(sql);
         
         while(rs.next()) {
        	 int id= rs.getInt(1);
        	 String cardtype= rs.getString(2);
        	 String cardholdername = rs.getString(3);
        	 int cardnumber = rs.getInt(4);
        	 String expmonth = rs.getString(5);
        	 String expyear = rs.getString(6);
        	 int cvn = rs.getInt(7);
        	 int amount = rs.getInt(7);
        	 
        	 CardModel cM = new CardModel(id,cardtype,cardholdername,cardnumber,expmonth,expyear,cvn,amount);
        	 card.add(cM);
         }
         

	}
	catch(Exception e) {
		e.printStackTrace();
	}
	
	return card;
}

//getAll data

	public static List<CardModel> getAllCard () {
	
	ArrayList <CardModel> cards = new ArrayList<>();
	
	try {
		//DBConnection
		 con = DBConnection.getConnection();
         stmt = con.createStatement();
         
         //Query
         String sql = "select * from card ";
         
         rs = stmt.executeQuery(sql);
         
         while(rs.next()) {
        	 int id= rs.getInt(1);
        	 String cardtype= rs.getString(2);
        	 String cardholdername = rs.getString(3);
        	 int cardnumber = rs.getInt(4);
        	 String expmonth = rs.getString(5);
        	 String expyear = rs.getString(6);
        	 int cvn = rs.getInt(7);
        	 int amount = rs.getInt(8);
        	 
        	 CardModel cM = new CardModel(id,cardtype,cardholdername,cardnumber,expmonth,expyear,cvn,amount);
        	 cards.add(cM);
         }
         

	}
	catch(Exception e) {
		e.printStackTrace();
	}
	
	return cards;
	
	
}
//Update Data
	public static boolean update(int id, String cardtype, String cardholdername,int cardnumber, String expmonth,String expyear, int cvn, int amount) {

		try {
			//DBConnection
			 con = DBConnection.getConnection();
	         stmt = con.createStatement();
	         
	         //SQL Query
	         String sql ="Update card set cardtype='"+cardtype+ "',cardholdername='"+cardholdername+"',cardnumber='"+cardnumber+"',expmonth='"+expmonth+"',expyear='"+expyear+"',cvn='"+cvn+"',amount='"+amount+"'"
	         	+"where id='"+id+"'";
	         
	         int rs = stmt.executeUpdate(sql);
	         
	         if (rs > 0) {
					isSuccess = true;
				} else {
					isSuccess = false;
				}
	         
	         
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return isSuccess;
	}
	
	//delete data
	
	public static boolean deletedata(String id) {
		int convID = Integer.parseInt(id);
		
		try {
			//DBConnection
			con = DBConnection.getConnection();
	        stmt = con.createStatement(); 
	        String sql = "DELETE FROM card WHERE id='"+convID+"'";
	         int rs = stmt.executeUpdate(sql);
	         if (rs > 0) {
					isSuccess = true;
				} else {
					isSuccess = false;
				}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return isSuccess;
	}
	
	
	
	
	
	
}
