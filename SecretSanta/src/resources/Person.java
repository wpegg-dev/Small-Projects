package resources;

import java.io.Serializable;

import org.json.simple.JSONAware;
import org.json.simple.JSONObject;

public class Person implements JSONAware, Serializable {

	private static final long serialVersionUID = -2025976363318866543L;
	
	private String personId;
	private String fName;
	private String lName;
	private String email;
	private String spouse;
	private String availability;
	private String assignedRecipientId;
	private String giftListId;

	public Person(String personId, String fName, String lName, String email,
			String spouse, String availability, String assignedRecipientId,
			String giftListId) {
		super();
		this.personId = personId;
		this.fName = fName;
		this.lName = lName;
		this.email = email;
		this.spouse = spouse;
		this.availability = availability;
		this.assignedRecipientId = assignedRecipientId;
		this.giftListId = giftListId;
	}


	@SuppressWarnings("unchecked")
	public String toJSONString() {
		JSONObject obj = new  JSONObject();
		
		obj.put("Person ID", this.personId);
		obj.put("First Name", this.fName);
		obj.put("Last Name", this.lName);
		obj.put("Email Address", this.email);
		obj.put("Spouse ID", this.spouse);
		obj.put("Availability", this.availability);
		obj.put("Assigned Recipient", this.assignedRecipientId);
		obj.put("Gift List ID", this.giftListId);
		
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
	
	public String getEmail() {
		return email;
	}


	public void setEmail(String email) {
		this.email = email;
	}


	public String getSpouse() {
		return spouse;
	}


	public void setSpouse(String spouse) {
		this.spouse = spouse;
	}


	public String getAvailability() {
		return availability;
	}


	public void setAvailability(String availability) {
		this.availability = availability;
	}


	public String getAssignedRecipientId() {
		return assignedRecipientId;
	}


	public void setAssignedRecipientId(String assignedRecipientId) {
		this.assignedRecipientId = assignedRecipientId;
	}


	public String getGiftListId() {
		return giftListId;
	}


	public void setGiftListId(String giftListId) {
		this.giftListId = giftListId;
	}

}
