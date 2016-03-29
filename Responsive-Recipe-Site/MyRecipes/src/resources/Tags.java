package resources;

import org.json.*;

public class Tags {
	private String tagId;
	private String recipeId;
	private String tag;
	
	public Tags(String tagId, String recipeId, String tag) {
		super();
		this.tagId = tagId;
		this.recipeId = recipeId;
		this.tag = tag;
	}
	
	public String toJSONString() {
		JSONObject obj = new  JSONObject();
		
		try {
			obj.put("Person ID", this.tagId);
			obj.put("First Name", this.recipeId);
			obj.put("Last Name", this.tag);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		return obj.toString();
	}

	public String getTagId() {
		return tagId;
	}

	public void setTagId(String tagId) {
		this.tagId = tagId;
	}

	public String getRecipeId() {
		return recipeId;
	}

	public void setRecipeId(String recipeId) {
		this.recipeId = recipeId;
	}

	public String getTag() {
		return tag;
	}

	public void setTag(String tag) {
		this.tag = tag;
	}
	
	
	
}
