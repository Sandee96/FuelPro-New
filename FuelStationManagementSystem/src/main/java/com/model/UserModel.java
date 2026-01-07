package com.model;

public class UserModel {
	
	private int userId;
    private String firstName;
    private String lastName;
    private String email;
    private String mobile;
    private int status;
    private String password;

	public UserModel() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param userId
	 * @param firstName
	 * @param lastName
	 * @param email
	 * @param mobile
	 * @param status
	 */
	public UserModel(int userId, String firstName, String lastName, String email, String mobile, int status, String password) {
		super();
		this.userId = userId;
		this.firstName = firstName;
		this.lastName = lastName;
		this.email = email;
		this.mobile = mobile;
		this.status = status;
		this.password = password;
	}

	public int getUserId() {
		return userId;
	}

	public String getFirstName() {
		return firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public String getEmail() {
		return email;
	}

	public String getMobile() {
		return mobile;
	}

	public int getStatus() {
		return status;
	}

	public String getPassword() {
		return password;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	
	
	

}
