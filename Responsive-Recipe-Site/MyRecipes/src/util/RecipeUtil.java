package util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import common.Queries;
import dbconnections.LocalDatabaseConnection;

public class RecipeUtil {
	
	private LocalDatabaseConnection lDbCon;
	private Connection conn;
	private int maxCount;
	private Vector<Integer> searchResults;
	
	public RecipeUtil(){
		this.lDbCon = new LocalDatabaseConnection();
		this.conn = lDbCon.getConnection();
		this.maxCount = getMaxRecipeId();
		this.searchResults = new Vector<Integer>();
	}
	
	public LocalDatabaseConnection getlDbCon() {
		return lDbCon;
	}

	public Connection getConn() {
		return conn;
	}

	public int getMaxCount() {
		return maxCount;
	}
	
	public Vector<Integer> getSearchResults(String searchText){
		String replacement = "%"+searchText+"%";
		LocalDatabaseConnection lDbCon2 = new LocalDatabaseConnection();
		Connection conn2 = lDbCon2.getConnection();
		try 
		{
			PreparedStatement ps = conn2.prepareStatement(Queries.GET_SEARCH_RESULTS);
			
			try
			{
				ps.setString(1, replacement);
				ps.setString(2, replacement);
				ps.setString(3, replacement);
				ps.setString(4, replacement);
				ps.setString(5, replacement);
				ResultSet rs = ps.executeQuery();
				
				try
				{
					while(rs.next())
					{
						searchResults.add(rs.getInt("rec_id"));
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
			lDbCon2.closeConnection();
		}
		finally
		{
			lDbCon2.closeConnection();
		}
		return searchResults;
	}

	private int getMaxRecipeId(){ 
		int maxIdValue = 0;
		try 
		{
			PreparedStatement ps = conn.prepareStatement(Queries.GET_ALL_RECIPE_IDS);
			
			try
			{
				ResultSet rs = ps.executeQuery();
				
				try
				{
					while(rs.next())
					{
						maxIdValue = rs.getInt("max_val");
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
		return maxIdValue;
	}
}
