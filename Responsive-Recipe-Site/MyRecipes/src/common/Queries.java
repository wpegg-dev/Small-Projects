package common;

public class Queries {
	
	public static final String GET_RECIPE_HEADER = 
			"SELECT rec_id, title, description, image_url FROM recipies.recipe WHERE rec_id = ?";
	
	public static final String GET_LAST_INSERTED_HEADER = 
			"SELECT MAX(rec_id) recipe_id from recipies.recipe";
	
	public static final String GET_RECIPE_INGREDIENTS = 
			"SELECT ingred_id, "+
			"   rec_id, "+
			"   ingredient, "+
			"   quantity, "+
			"   measurement "+
			"FROM recipies.ingredients "+
			"WHERE rec_id = ?";
	
	public static final String GET_RECIPE_STEPS = 
			"SELECT step_id, "+
			"    rec_id, "+
			"    order_num, "+
			"    directive "+
			"FROM recipies.steps "+
			"WHERE rec_id = ?";
	
	public static final String GET_RECIPE_TAGS =
			"SELECT tag_id, "+
			"    rec_id, "+
			"    tag "+
			"FROM recipies.tags "+
			"WHERE rec_id = ?";
	
	public static final String INSERT_RECIPE_TAGS =
			"INSERT INTO recipies.tags (rec_id,tag) VALUES(?,?)";
	
	public static final String INSERT_RECIPE_STEPS =
			"INSERT INTO recipies.steps(rec_id,order_num,directive) VALUES(?,?,?)";

	public static final String INSERT_RECIPE_INGREDIENTS =
			"INSERT INTO recipies.ingredients(rec_id,ingredient,quantity,measurement) VALUES(?,?,?,?)";
	
	public static final String INSERT_RECIPE_HEADER =
			"INSERT INTO recipies.recipe(title,description,image_url) VALUES(?,?,?)";
	
	public static final String GET_ALL_RECIPE_IDS = 
			"SELECT MAX(rec_id) max_val FROM recipies.recipe";
	
	public static final String GET_SEARCH_RESULTS = 
			"SELECT distinct r.rec_id "+
			"FROM recipies.recipe r "+
			"	LEFT OUTER JOIN recipies.ingredients i "+
			"		ON r.rec_id=i.rec_id "+
			"	LEFT OUTER JOIN recipies.steps s "+
			"		ON r.rec_id=i.rec_id "+
			"	LEFT OUTER JOIN recipies.tags t "+
			"		ON r.rec_id=t.rec_id "+
			"WHERE upper(r.title) LIKE upper(?) "+
			"OR upper(r.description) LIKE upper(?) "+
			"OR upper(t.tag) LIKE upper(?) "+
			"OR upper(s.directive) LIKE upper(?) "+
			"OR upper(i.ingredient) LIKE upper(?)";
	
}
