package resources;

import org.json.*;

public class Steps {
	private String stepId;
	private String recipeId;
	private String orderNumber;
	private String directive;
	
	public Steps(String stepId, String recipeId, String orderNumber, String directive) {
		super();
		this.stepId = stepId;
		this.recipeId = recipeId;
		this.orderNumber = orderNumber;
		this.directive = directive;
	}

	public String toJSONString() {
		JSONObject obj = new  JSONObject();
		
		try {
			obj.put("Person ID", this.stepId);
			obj.put("First Name", this.recipeId);
			obj.put("Last Name", this.orderNumber);
			obj.put("Last Name", this.directive);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		return obj.toString();
	}
	
	public String getStepId() {
		return stepId;
	}

	public void setStepId(String stepId) {
		this.stepId = stepId;
	}

	public String getRecipeId() {
		return recipeId;
	}

	public void setRecipeId(String recipeId) {
		this.recipeId = recipeId;
	}

	public String getOrderNumber() {
		return orderNumber;
	}

	public void setOrderNumber(String orderNumber) {
		this.orderNumber = orderNumber;
	}

	public String getDirective() {
		return directive;
	}

	public void setDirective(String directive) {
		this.directive = directive;
	}
	
	
	
}
