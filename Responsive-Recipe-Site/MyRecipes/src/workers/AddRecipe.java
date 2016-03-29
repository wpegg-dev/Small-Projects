package workers;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;
import common.Queries;
import dbconnections.LocalDatabaseConnection;
import resources.Ingredients;
import resources.Recipe;
import resources.Steps;
import resources.Tags;

public class AddRecipe implements Serializable, Runnable {

	private static final long serialVersionUID = -4511753628691258566L;

	private Recipe recipe;
	private Vector<Ingredients> ingredients;
	private Vector<Tags> tags;
	private String message;
	
	public AddRecipe(Recipe recipe){
		this.recipe = recipe;
		this.ingredients = recipe.getIngredients();
		this.tags = recipe.getTags();
	}
	@Override
	public void run() {
		this.addRecipe(recipe);
	}
	
	private void addRecipe(Recipe rec){
		String title = rec.getTitle(); 
		String desc = rec.getDescription();
		String imageUrl = rec.getImageUrl();
		this.message = insertRecord(title,desc,imageUrl);
	}
	
	public String getMessage(){
		return this.message;
	}
	
	private String insertRecord(String title, String desc, String imageUrl){
		
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		Connection conn = lDbCon.getConnection();
		String message = "Failed to add recipe. Please try again.";
		String recipeId = "";
		try 
		{
			PreparedStatement ps = conn.prepareStatement(Queries.INSERT_RECIPE_HEADER);
			PreparedStatement psGet = conn.prepareStatement(Queries.GET_LAST_INSERTED_HEADER);
			PreparedStatement ps1 = conn.prepareStatement(Queries.INSERT_RECIPE_STEPS);
			
			try
			{
				ps.setString(1, title);
				ps.setString(2, desc);
				ps.setString(3, imageUrl);
				ps.executeUpdate();
				
				ResultSet rs = psGet.executeQuery();
				try
				{
					while(rs.next())
					{recipeId = rs.getString("recipe_id");}
				}
				finally
				{rs.close();}
				Steps step = this.recipe.getSteps().get(0);
				ps1.setString(1, recipeId);
				ps1.setString(2, step.getOrderNumber());
				ps1.setString(3, step.getDirective());
				ps1.executeUpdate();
				
				for(int i=0;i<this.tags.size();i++){
					Tags tag = this.tags.get(i);
					tag.setRecipeId(recipeId);
					insertTags(tag);
				}
				
				for(int i=0;i<this.ingredients.size();i++){
					Ingredients ingredient = this.ingredients.get(i);
					ingredient.setRecipeId(recipeId);
					insertIngredients(ingredient);
				}
				
				message = "Recipe added successfully!";
				
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
		
		return message;
	}
	
	private void insertTags(Tags t){
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		Connection conn = lDbCon.getConnection();
		try 
		{
			PreparedStatement psT = conn.prepareStatement(Queries.INSERT_RECIPE_TAGS);
			
			try
			{
				psT.setString(1, t.getRecipeId());
				psT.setString(2, t.getTag());
				psT.executeUpdate();
			}
			finally
			{
				psT.close();
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
	
	private void insertIngredients(Ingredients in){
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		Connection conn = lDbCon.getConnection();
		try 
		{
			PreparedStatement psI = conn.prepareStatement(Queries.INSERT_RECIPE_INGREDIENTS);
			
			try
			{
				psI.setString(1, in.getRecipeId());
				psI.setString(2, in.getIngredient());
				psI.setString(3, in.getQuantity());
				psI.setString(4, in.getMeasurement());
				psI.executeUpdate();
			}
			finally
			{
				psI.close();
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

}
