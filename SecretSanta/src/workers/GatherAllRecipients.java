package workers;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import common.Queries;
import dbconnection.LocalDatabaseConnection;
import resources.PersonAndRecipient;

public class GatherAllRecipients implements Runnable, Serializable {

	private static final long serialVersionUID = -3680266250615371725L;
	
	private Vector<PersonAndRecipient> recip;

	public GatherAllRecipients() {
		super();
		recip = new Vector<PersonAndRecipient>();
	}

	@Override
	public void run() {
		getAllRecips();
	}
	
	private void getAllRecips(){
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		
		Connection conn = lDbCon.getConnection();
		try 
		{
			PreparedStatement ps = conn.prepareStatement(Queries.GATHER_FULL_RECIPIENT_LIST);
			
			try
			{
				
				ResultSet rs = ps.executeQuery();
				
				try
				{
					while(rs.next())
					{
						String personId = rs.getString("PersonID");
						String personName = rs.getString("FullName");
						String recipientName = rs.getString("RecipientName");
						//String giftListID = rs.getString("GiftListId");
						
						this.recip.add(new PersonAndRecipient(personId, personName, recipientName));
						
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

	public Vector<PersonAndRecipient> getRecip() {
		return recip;
	}
}
