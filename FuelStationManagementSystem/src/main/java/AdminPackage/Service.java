package AdminPackage;

public class Service {
	
	int id;
	String vehiclenumber;
	String servicetype;
	String servicestation;
	String date;
	String time;
	
	
	@Override
	public String toString() {
		return "Service [id=" + id + ", vehiclenumber=" + vehiclenumber + ", servicetype=" + servicetype
				+ ", servicestation=" + servicestation + ", date=" + date + ", time=" + time + "]";
	}


	public Service(String vehiclenumber, String servicetype, String servicestation, String date, String time) {
		super();
		this.vehiclenumber = vehiclenumber;
		this.servicetype = servicetype;
		this.servicestation = servicestation;
		this.date = date;
		this.time = time;
	}


	public Service() {
		super();
		// TODO Auto-generated constructor stub
	}


	public Service(int id, String vehiclenumber, String servicetype, String servicestation, String date,
			String time) {
		super();
		this.id = id;
		this.vehiclenumber = vehiclenumber;
		this.servicetype = servicetype;
		this.servicestation = servicestation;
		this.date = date;
		this.time = time;
	}
	
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getVehiclenumber() {
		return vehiclenumber;
	}
	public void setVehiclenumber(String vehiclenumber) {
		this.vehiclenumber = vehiclenumber;
	}
	public String getServicetype() {
		return servicetype;
	}
	public void setServicetype(String servicetype) {
		this.servicetype = servicetype;
	}
	public String getServicestation() {
		return servicestation;
	}
	public void setServicestation(String servicestation) {
		this.servicestation = servicestation;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	
    
}
