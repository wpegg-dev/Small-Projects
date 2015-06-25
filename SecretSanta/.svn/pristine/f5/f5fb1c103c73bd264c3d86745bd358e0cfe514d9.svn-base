package resources;

import java.io.Serializable;

import org.json.simple.JSONAware;
import org.json.simple.JSONObject;

public class PersonAndRecipient implements JSONAware, Serializable {

	private static final long serialVersionUID = -127742410595684366L;
	
	private String PersonId;
	private String PersonName;
	private String RecipientName;

	public PersonAndRecipient(String personId, String personName,
			String recipientName) {
		super();
		PersonId = personId;
		PersonName = personName;
		RecipientName = recipientName;
	}

	@SuppressWarnings("unchecked")
	public String toJSONString() {
		JSONObject obj = new  JSONObject();
		
		obj.put("Person ID", this.PersonId);
		obj.put("Person Name", this.PersonName);
		obj.put("Recipient Name", this.RecipientName);
		
		return obj.toJSONString();
	}

	public String getPersonId() {
		return PersonId;
	}

	public void setPersonId(String personId) {
		PersonId = personId;
	}

	public String getPersonName() {
		return PersonName;
	}

	public void setPersonName(String personName) {
		PersonName = personName;
	}

	public String getRecipientName() {
		return RecipientName;
	}

	public void setRecipientName(String recipientName) {
		RecipientName = recipientName;
	}

}
