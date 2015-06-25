package resources;

import java.io.Serializable;

import org.json.simple.JSONAware;
import org.json.simple.JSONObject;

public class GiftData implements JSONAware, Serializable {

	private static final long serialVersionUID = 3589328421561505077L;
	
	private String giftId;
	private String giftName;
	private String description;
	private String url;
	private String priority;
	private String addDate;

	public GiftData(String giftId, String giftName, String description,
			String url, String priority, String addDate) {
		super();
		this.giftId = giftId;
		this.giftName = giftName;
		this.description = description;
		this.url = url;
		this.priority = priority;
		this.addDate = addDate;
	}

	@SuppressWarnings("unchecked")
	public String toJSONString() {
		JSONObject obj = new  JSONObject();
		
		obj.put("Gift ID", this.giftId);
		obj.put("Gift Name", this.giftName);
		obj.put("Gift Description", this.description);
		obj.put("URL", this.url);
		obj.put("Priority", this.priority);
		obj.put("Add Date", this.addDate);
		
		return obj.toJSONString();
	}

	public String getGiftId() {
		return giftId;
	}

	public void setGiftId(String giftId) {
		this.giftId = giftId;
	}

	public String getGiftName() {
		return giftName;
	}

	public void setGiftName(String giftName) {
		this.giftName = giftName;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getPriority() {
		return priority;
	}

	public void setPriority(String priority) {
		this.priority = priority;
	}

	public String getAddDate() {
		return addDate;
	}

	public void setAddDate(String addDate) {
		this.addDate = addDate;
	}

}
