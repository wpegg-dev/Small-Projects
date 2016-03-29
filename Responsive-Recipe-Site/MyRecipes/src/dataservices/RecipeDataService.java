package dataservices;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import resources.Ingredients;
import resources.Recipe;
import resources.Steps;
import resources.Tags;
import util.RecipeUtil;
import workers.AddRecipe;
import workers.GetRecipe;

/**
 * Servlet implementation class RecipeDataService
 */
@WebServlet("/RecipeDataService")
public class RecipeDataService extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RecipeDataService() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json");
		PrintWriter pw = response.getWriter();
		
		if(("getSingleRecipe").equals(request.getParameter("method")))
		{
			if(!(request.getParameter("recipeId")).equals("") && request.getParameter("recipeId") != null)
			{
				String recipeId = request.getParameter("recipeId");
				
				GetRecipe gr = new GetRecipe(recipeId);
				Thread grt = new Thread(gr);
				grt.run();
				waitForThread(grt);

				JSONObject output = new JSONObject();
	
				try {
					output.put("recipeDataModal",gr.getRecipeInfo());
					pw.println(output.toString());
				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
		}
		else if(("loadHomePage").equals(request.getParameter("method"))){
			RecipeUtil util = new RecipeUtil();
			int maxLimit = util.getMaxCount();
			JSONObject output = new JSONObject();
			JSONArray outputArray = new JSONArray();
			
			ArrayList<Integer> list = new ArrayList<Integer>();
	        for (int i=1; i<maxLimit+1; i++) {
	            list.add(new Integer(i));
	        }
	        Collections.shuffle(list);
	        
	        if(maxLimit > 15){
	        	for (int i=0; i<15; i++) {
		        	String recipeId = ""+list.get(i);
					GetRecipe gr = new GetRecipe(recipeId);
					Thread grt = new Thread(gr);
					grt.run();
					waitForThread(grt);
					outputArray.put(gr.getRecipeInfo());
		        }
	        }
	        else{
	        	for (int i=0; i<maxLimit; i++) {
		        	String recipeId = ""+list.get(i);
					GetRecipe gr = new GetRecipe(recipeId);
					Thread grt = new Thread(gr);
					grt.run();
					waitForThread(grt);
					outputArray.put(gr.getRecipeInfo());
		        }
	        }
	        			

			try {
				output.put("recipeData",outputArray);
				pw.println(output.toString());
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		else if(("addRecipe").equals(request.getParameter("method"))){
			JSONObject output = new JSONObject();
			String outputMessage = "Failed to add recipe. Please try again.";
			if(!(request.getParameter("recipeTitle")).equals("") && request.getParameter("recipeTitle") != null
					&& !(request.getParameter("description")).equals("") && request.getParameter("description") != null
					&& !(request.getParameter("steps")).equals("") && request.getParameter("steps") != null
					&& !(request.getParameter("ingredients")).equals("") && request.getParameter("ingredients") != null)
			{
				try{
					String title = request.getParameter("recipeTitle");
					String description = request.getParameter("description");
					String imageUrl = request.getParameter("imageUrl");
					String steps = request.getParameter("steps");
					
					Recipe r = new Recipe(title, description, imageUrl);
					
					Vector<Steps> s = new Vector<Steps>();
					s.add(new Steps("1", "0", "1", steps));
					r.setSteps(s);
					
					Vector<Ingredients> ingreds = new Vector<Ingredients>();
					JSONObject ingredients = new JSONObject(request.getParameter("ingredients"));
					for(int i=1;i<=ingredients.length();i++){
						String idToGet = "ingredient"+i;
						JSONObject curIngred = ingredients.getJSONObject(idToGet);
						String ingred = curIngred.getString("ingredient");
						String quantity = curIngred.getString("quantity");
						String measurement = curIngred.getString("measurement");
						ingreds.add(new Ingredients("0", "0", ingred, quantity, measurement));
					}
					r.setIngredients(ingreds);
					
					Vector<Tags> tagList = new Vector<Tags>();
					JSONObject tags = new JSONObject(request.getParameter("tags"));
					for(int i=1;i<=tags.length();i++){
						String idToGet = "tag"+i;
						JSONObject curTag = tags.getJSONObject(idToGet);
						String tag = curTag.getString("tag");
						tagList.add(new Tags("0", "0", tag));
					}
					r.setTags(tagList);
					
					AddRecipe ar = new AddRecipe(r);
					Thread art = new Thread(ar);
					art.run();
					waitForThread(art);
					
					outputMessage = ar.getMessage();
					
					output.put("message",outputMessage);
					pw.println(output.toString());
					
				}
				catch(JSONException e){
					e.printStackTrace();
				}
			}
		}
		else if(("searchRecipes").equals(request.getParameter("method"))){
			if(!(request.getParameter("searchText")).equals("") && request.getParameter("searchText") != null){
				String searchString = request.getParameter("searchText");
				RecipeUtil util = new RecipeUtil();
				Vector<Integer> searchRecipeIds = util.getSearchResults(searchString);
				JSONObject output = new JSONObject();
				JSONArray outputArray = new JSONArray();
				
		        Collections.shuffle(searchRecipeIds);
		        
	        	for (int i=0; i<searchRecipeIds.size(); i++) {
		        	String recipeId = ""+searchRecipeIds.get(i);
					GetRecipe gr = new GetRecipe(recipeId);
					Thread grt = new Thread(gr);
					grt.run();
					waitForThread(grt);
					outputArray.put(gr.getRecipeInfo());
		        }

				try {
					output.put("recipeData",outputArray);
					pw.println(output.toString());
				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	private void waitForThread(Thread thread)
	{
		if(thread.isAlive())
		{
			try
			{
				thread.join();
			}
			catch(InterruptedException e)
			{
				System.out.println("Thread Interrupted: "+e.getMessage());
			}
		}
	}	

}
