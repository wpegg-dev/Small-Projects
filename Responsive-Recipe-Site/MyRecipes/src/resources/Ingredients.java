package resources;

import org.json.*;

public class Ingredients {
	private String ingredientId;
	private String recipeId;
	private String ingredient;
	private String quantity;
	private String measurement;
	
	public Ingredients(String ingredientId, String recipeId, String ingredient, String quantity, String measurement) {
		super();
		this.ingredientId = ingredientId;
		this.recipeId = recipeId;
		this.ingredient = ingredient;
		this.quantity = quantity;
		this.measurement = measurement;
	}

	public String toJSONString() {
		JSONObject obj = new  JSONObject();
		
		try {
			obj.put("Person ID", this.ingredientId);
			obj.put("First Name", this.recipeId);
			obj.put("Last Name", this.ingredient);
			obj.put("Last Name", this.quantity);
			obj.put("Last Name", this.measurement);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		return obj.toString();
	}
	
	public String getIngredientId() {
		return ingredientId;
	}

	public void setIngredientId(String ingredientId) {
		this.ingredientId = ingredientId;
	}

	public String getRecipeId() {
		return recipeId;
	}

	public void setRecipeId(String recipeId) {
		this.recipeId = recipeId;
	}

	public String getIngredient() {
		return ingredient;
	}

	public void setIngredient(String ingredient) {
		this.ingredient = ingredient;
	}

	public String getQuantity() {
		return quantity;
	}

	public void setQuantity(String quantity) {
		this.quantity = quantity;
	}

	public String getMeasurement() {
		return measurement;
	}

	public void setMeasurement(String measurement) {
		this.measurement = measurement;
	}

}

