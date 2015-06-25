package workers;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import common.Queries;

import dbconnection.LocalDatabaseConnection;
import resources.GiftData;

public class GatherRecipientGiftList implements Runnable, Serializable {

	private static final long serialVersionUID = 8935860085265707702L;
	
	private String personId;
	private Vector<GiftData> gifts;

	public GatherRecipientGiftList(String personId) {
		super();
		this.personId = personId;
		gifts = new Vector<GiftData>();
	}

	@Override
	public void run() {
		getGifts();
	}
	
	private void getGifts() {
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		
		Connection conn = lDbCon.getConnection();
		try 
		{
			PreparedStatement ps = conn.prepareStatement(Queries.GIFT_GET_LIST);
			
			try
			{
				ps.setInt(1, Integer.parseInt(personId));
				
				ResultSet rs = ps.executeQuery();
				
				try
				{
					while(rs.next())
					{
						String giftId = rs.getString("GiftId");
						String gName = rs.getString("GiftName");
						String gDescr = rs.getString("GiftDescription");
						String url = rs.getString("GiftUrl");
						String giftPri = rs.getString("GiftOrder");
						String giftAddDate = rs.getString("AddDate");
						
						this.gifts.add(new GiftData(giftId, gName, gDescr, url, giftPri, giftAddDate));
						
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
	}

	public Vector<GiftData> getGiftList() {
		return gifts;
	}

}
