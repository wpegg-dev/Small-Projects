package resources;

import java.io.Serializable;

import org.json.simple.JSONAware;
import org.json.simple.JSONObject;

public class UserData implements JSONAware, Serializable {

	private static final long serialVersionUID = 1110736239442413928L;
	
	private String fName;
	private String lName;
	private String personId;
	private String emailAddress;
	private String userType;

	public UserData(String personId, String fName, String lName, 
			String emailAddress, String userType) {
		super();
		this.fName = fName;
		this.lName = lName;
		this.personId = personId;
		this.emailAddress = emailAddress;
		this.userType = userType;
	}

	@SuppressWarnings("unchecked")
	public String toJSONString() {
		JSONObject obj = new  JSONObject();
		
		obj.put("Person ID", this.personId);
		obj.put("Full Name", this.fName+" "+this.lName);
		obj.put("First Name", this.fName);
		obj.put("Last Name", this.lName);
		obj.put("Email Address", this.emailAddress);
		obj.put("User Type", this.userType);
		
		return obj.toJSONString();

		
	}

	

	public String getfName() {
		return fName;
	}

	public void setfName(String fName) {
		this.fName = fName;
	}

	public String getlName() {
		return lName;
	}

	public void setlName(String lName) {
		this.lName = lName;
	}

	public String getPersonId() {
		return personId;
	}

	public void setPersonId(String personId) {
		this.personId = personId;
	}

	public String getEmailAddress() {
		return emailAddress;
	}

	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}

}
