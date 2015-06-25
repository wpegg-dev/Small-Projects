package workers;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import common.Queries;

import dbconnection.LocalDatabaseConnection;

public class AddMyGift implements Runnable, Serializable {

	private static final long serialVersionUID = -3513921369461799230L;
	
	private String giftName;
	private String giftDescr;
	private String giftUrl;
	private String personId;

	public AddMyGift(String giftName, String giftDescr, String giftUrl,
			String personId) {
		super();
		this.giftName = giftName;
		this.giftDescr = giftDescr;
		this.giftUrl = giftUrl;
		this.personId = personId;
	}

	@Override
	public void run() {
		this.addGift();
	}
	
	private void addGift()
	{
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		
		Connection conn = lDbCon.getConnection();
		try 
		{
			PreparedStatement ps = conn.prepareStatement(Queries.ADD_GIFT_TO_LIST);
			
			try
			{
				
				ps.setString(1, personId);
				ps.setString(2, giftName);
				ps.setString(3, giftDescr);
				ps.setString(4, giftUrl);
				
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
