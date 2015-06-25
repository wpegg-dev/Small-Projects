package workers;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import common.Queries;
import dbconnection.LocalDatabaseConnection;

public class RemoveMyGift implements Runnable, Serializable {

	private static final long serialVersionUID = -2642213070935393103L;
	
	private String giftId;
	private String personId;
	
	

	public RemoveMyGift(String giftId, String personId) {
		super();
		this.giftId = giftId;
		this.personId = personId;
	}



	@Override
	public void run() {
		this.removeGift();
	}
	
	private void removeGift(){
		
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		
		Connection conn = lDbCon.getConnection();
		try 
		{
			PreparedStatement ps = conn.prepareStatement(Queries.REMOVE_GIFT_FROM_LIST);
			
			try
			{
				
				ps.setString(1, giftId);
				ps.setString(2, personId);
				
				ps.executeUpdate();
				
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

}
