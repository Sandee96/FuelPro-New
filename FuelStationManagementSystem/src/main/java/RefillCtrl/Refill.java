package RefillCtrl;

public class Refill {
	
	private String FuelStation;
	private String FuelType;
	private int Amount;
	
	public String getFuelStation() {
		return FuelStation;
	}
	public String getFuelType() {
		return FuelType;
	}
	public int getAmount() {
		return Amount;
	}
	
	public void setFuelStation(String fuelStation) {
		FuelStation = fuelStation;
	}
	public void setFuelType(String fuelType) {
		FuelType = fuelType;
	}
	public void setAmount(int amount) {
		Amount = amount;
	}
	
	public double CalPay(double unitPrice, float userAmount) {
		
		return unitPrice * userAmount;
		
	}
	
	
	
	
	

}
