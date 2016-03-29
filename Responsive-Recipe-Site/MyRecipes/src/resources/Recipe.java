package resources;

import java.util.Vector;

import org.json.*;
import resources.*;

public class Recipe {
	private String recipeId;
	private String title;
	private String description;
	private String imageUrl;
	private Vector<Steps> steps;
	private Vector<Ingredients> ingredients;
	private Vector<Tags> tags;
	
	public Recipe(String title, String description, String imageUrl) {
		super();
		this.title = title;
		this.description = description;
		this.imageUrl = imageUrl;
		this.steps = new Vector<Steps>();
		this.ingredients = new Vector<Ingredients>();
		this.tags = new Vector<Tags>();
	}
	public Recipe(String recipeId, String title, String description, String imageUrl) {
		super();
		this.recipeId = recipeId;
		this.title = title;
		this.description = description;
		this.imageUrl = imageUrl;
		this.steps = new Vector<Steps>();
		this.ingredients = new Vector<Ingredients>();
		this.tags = new Vector<Tags>();
	}

	public String toJSONString() {
		String returnVal = "";
		JSONObject obj = new  JSONObject();
		
		JSONArray stepArray = new JSONArray();
		JSONArray ingredArray = new JSONArray();
		JSONArray tagsArray = new JSONArray();
		
		try {
			obj.put("RecipeID", this.recipeId);
			obj.put("Title", this.title);
			obj.put("Description", this.description);
			obj.put("ImageUrl", this.imageUrl);
			
			for(int i=0; i<steps.size();i++)
			{
				JSONObject objSteps = new  JSONObject();
				Steps curStep = steps.get(i);
				objSteps.put("RecipeID", curStep.getRecipeId());
				objSteps.put("StepID", curStep.getStepId());
				objSteps.put("StepOrder", curStep.getOrderNumber());
				objSteps.put("Directive", curStep.getDirective());
				stepArray.put(objSteps);
			}
			for(int i=0; i<ingredients.size();i++)
			{
				JSONObject objIngred = new  JSONObject();
				Ingredients curIngred = ingredients.get(i);
				objIngred.put("RecipeID", curIngred.getRecipeId());
				objIngred.put("IngredientID", curIngred.getIngredientId());
				objIngred.put("Ingredient", curIngred.getIngredient());
				objIngred.put("Quantity", curIngred.getQuantity());
				objIngred.put("Measurement", curIngred.getMeasurement());
				ingredArray.put(objIngred);
			}
			for(int i=0; i<tags.size();i++)
			{
				JSONObject objTags = new  JSONObject();
				Tags curTag = tags.get(i);
				objTags.put("RecipeID", curTag.getRecipeId());
				objTags.put("TagID", curTag.getTagId());
				objTags.put("Tag", curTag.getTag());
				tagsArray.put(objTags);
			}
			
			obj.put("Steps", stepArray);
			obj.put("Ingredients", ingredArray);
			obj.put("Tags", tagsArray);
			
			returnVal = obj.toString();
			
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		return returnVal;
	}
	
	public String getRecipeId() {
		return recipeId;
	}

	public void setRecipeId(String recipeId) {
		this.recipeId = recipeId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public Vector<Steps> getSteps() {
		return steps;
	}

	public Vector<Ingredients> getIngredients() {
		return ingredients;
	}

	public Vector<Tags> getTags() {
		return tags;
	}

	public void setSteps(Vector<Steps> steps) {
		this.steps = steps;
	}

	public void setIngredients(Vector<Ingredients> ingredients) {
		this.ingredients = ingredients;
	}

	public void setTags(Vector<Tags> tags) {
		this.tags = tags;
	}
}
