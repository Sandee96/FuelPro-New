package PaymentPackage;

public class CardModel {

	private int id;
	private String cardtype;
	private String cardholdername;
	private int cardnumber;
	private String expmonth;
	private String expyear;
	private int cvn;
	private int amount;
	
	public CardModel(int id, String cardtype, String cardholdername, int cardnumber, String expmonth, String expyear,
			int cvn, int amount) {
		super();
		this.id = id;
		this.cardtype = cardtype;
		this.cardholdername = cardholdername;
		this.cardnumber = cardnumber;
		this.expmonth = expmonth;
		this.expyear = expyear;
		this.cvn = cvn;
		this.amount = amount;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getCardtype() {
		return cardtype;
	}
	public void setCardtype(String cardtype) {
		this.cardtype = cardtype;
	}
	public String getCardholdername() {
		return cardholdername;
	}
	public void setCardholdername(String cardholdername) {
		this.cardholdername = cardholdername;
	}
	public int getCardnumber() {
		return cardnumber;
	}
	public void setCardnumber(int cardnumber) {
		this.cardnumber = cardnumber;
	}
	public String getExpmonth() {
		return expmonth;
	}
	public void setExpmonth(String expmonth) {
		this.expmonth = expmonth;
	}
	public String getExpyear() {
		return expyear;
	}
	public void setExpyear(String expyear) {
		this.expyear = expyear;
	}
	public int getCvn() {
		return cvn;
	}
	public void setCvn(int cvn) {
		this.cvn = cvn;
	}
	public int getAmount() {
		return amount;
	}
	public void setAmount(int amount) {
		this.amount = amount;
	}
	

	
	
	
	
	
}