package workers;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import org.json.JSONArray;
import org.json.JSONObject;

import common.Queries;
import dbconnections.LocalDatabaseConnection;
import resources.Ingredients;
import resources.Recipe;
import resources.Steps;
import resources.Tags;

public class GetRecipe implements Serializable, Runnable {

	private static final long serialVersionUID = 2520345287983467463L;

	private String recipeId;
	private Recipe recipe;
	private Vector<Steps> steps;
	private Vector<Ingredients> ingredients;
	private Vector<Tags> tags;

	public GetRecipe(String recipeId) {
		super();
		this.recipeId = recipeId;
		this.recipe = new Recipe(recipeId, "", "", "");
		this.steps = new Vector<Steps>();
		this.ingredients = new Vector<Ingredients>();
		this.tags = new Vector<Tags>();
	}

	@Override
	public void run() {
		getRecipe(recipeId);
	}
	
	private void getRecipe(String recipeId){
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		Connection conn = lDbCon.getConnection();
		try 
		{
			PreparedStatement ps = conn.prepareStatement(Queries.GET_RECIPE_HEADER);
			
			try
			{
				ps.setString(1, recipeId);
				ResultSet rs = ps.executeQuery();
				
				try
				{
					while(rs.next())
					{
						String title = rs.getString("title");
						String description = rs.getString("description");
						String imageUrl = rs.getString("image_url");
						this.recipe = new Recipe(recipeId, title, description, imageUrl);
					}
				}
				finally
				{
					rs.close();
				}
			}
			finally
			{
				ps.close();
			}	
		} 
		catch (SQLException e) 
		{
			lDbCon.closeConnection();
		}
		finally
		{
			lDbCon.closeConnection();
		}
		
		getIngredients(recipeId);
		getSteps(recipeId);
		getTags(recipeId);
	}
	
	private void getIngredients(String recipeId){
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		Connection conn = lDbCon.getConnection();
		
		try 
		{
			PreparedStatement ps = conn.prepareStatement(Queries.GET_RECIPE_INGREDIENTS);
			
			try
			{
				ps.setString(1, recipeId);
				ResultSet rs = ps.executeQuery();
				
				try
				{
					while(rs.next())
					{
						String ingredientId = rs.getString("ingred_id");
						String ingredient = rs.getString("ingredient");
						String quantity = rs.getString("quantity");
						String measurement = rs.getString("measurement");
						this.ingredients.add(new Ingredients(ingredientId, recipeId, ingredient, quantity, measurement));
					}
					
					this.recipe.setIngredients(this.ingredients);
				}
				finally
				{
					rs.close();
				}
			}
			finally
			{
				ps.close();
			}	
		} 
		catch (SQLException e) 
		{
			lDbCon.closeConnection();
		}
		finally
		{
			lDbCon.closeConnection();
		}
	}
	
	private void getSteps(String recipeId){
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		Connection conn = lDbCon.getConnection();
		
		try 
		{
			PreparedStatement ps = conn.prepareStatement(Queries.GET_RECIPE_STEPS);
			
			try
			{
				ps.setString(1, recipeId);
				ResultSet rs = ps.executeQuery();
				
				try
				{
					while(rs.next())
					{
						String stepId = rs.getString("step_id");
						String orderNumber = rs.getString("order_num");
						String directive = rs.getString("directive");
						this.steps.add(new Steps(stepId, recipeId, orderNumber, directive));
					}
					
					this.recipe.setSteps(this.steps);
				}
				finally
				{
					rs.close();
				}
			}
			finally
			{
				ps.close();
			}	
		} 
		catch (SQLException e) 
		{
			lDbCon.closeConnection();
		}
		finally
		{
			lDbCon.closeConnection();
		}
	}
	
	private void getTags(String recipeId){
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		Connection conn = lDbCon.getConnection();
		
		try 
		{
			PreparedStatement ps = conn.prepareStatement(Queries.GET_RECIPE_TAGS);
			
			try
			{
				ps.setString(1, recipeId);
				ResultSet rs = ps.executeQuery();
				
				try
				{
					while(rs.next())
					{
						String tagId = rs.getString("tag_id");
						String tag = rs.getString("tag");
						this.tags.add(new Tags(tagId, recipeId, tag));
					}
					
					this.recipe.setTags(this.tags);
				}
				finally
				{
					rs.close();
				}
			}
			finally
			{
				ps.close();
			}	
		} 
		catch (SQLException e) 
		{
			lDbCon.closeConnection();
		}
		finally
		{
			lDbCon.closeConnection();
		}
	}
	
	public String getRecipeInfo(){
		return recipe.toJSONString();
	}

}
