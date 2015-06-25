package workers;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.Vector;

import common.Queries;
import dbconnection.LocalDatabaseConnection;
import resources.Person;

public class GetRecipient implements Runnable, Serializable {

	private static final long serialVersionUID = 7264299765220916620L;
	
	private String personId;
	private Vector<Person> recip;
	private Vector<Integer> availRecip;
	private Integer hasRecipient;

	public GetRecipient(String personId) {
		super();
		this.personId = personId;
		this.hasRecipient = 0;
		this.recip = new Vector<Person>();
		this.availRecip = new Vector<Integer>();
	}

	@Override
	public void run() {
		checkForRecipient();
		if(hasRecipient == 0)
		{
			getAvailableMembers();
			getNewUserRecipient();
		}
		else
		{
			getUserRecipient(hasRecipient);
		}
		
	}

	private void checkForRecipient(){
		
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		
		Connection conn = lDbCon.getConnection();
		try 
		{
			PreparedStatement ps = conn.prepareStatement(Queries.CHECK_FOR_USERS_RECIPIENT);
			
			try
			{
				ps.setString(1, personId);
				
				ResultSet rs = ps.executeQuery();
				
				try
				{
					while(rs.next())
					{
						Integer check = Integer.parseInt(rs.getString("Recipient"));
						
						if(check > 0)
						{
							hasRecipient = check;
						}
						
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
	
	private void getAvailableMembers(){
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		
		Connection conn = lDbCon.getConnection();
		try 
		{
			PreparedStatement ps = conn.prepareStatement(Queries.GATHER_AVAILABLE_RECIPIENTS);
			
			try
			{
				ps.setString(1, personId);
				ps.setString(2, personId);
				
				ResultSet rs = ps.executeQuery();
				
				try
				{
					while(rs.next())
					{
						Integer personId = Integer.parseInt(rs.getString("PersonId"));
						
						this.availRecip.add(personId);
						
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
	
	private void getNewUserRecipient(){
		
		Collections.shuffle(availRecip);
		
		Integer curPerson = availRecip.firstElement();
		
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		
		Connection conn = lDbCon.getConnection();
		try 
		{
			PreparedStatement ps = conn.prepareStatement(Queries.SET_RECIPIENT);
			PreparedStatement ps1 = conn.prepareStatement(Queries.SET_RECIPIENT_AVAILABILITY);
			
			try
			{
				ps.setInt(1, curPerson);
				ps.setInt(2, Integer.parseInt(personId));
				
				ps1.setInt(1, curPerson);
				
				ps.executeUpdate();
				ps1.executeUpdate();
				
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
	
	private void getUserRecipient(Integer recipId){
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		
		Connection conn = lDbCon.getConnection();
		try 
		{
			PreparedStatement ps = conn.prepareStatement(Queries.GET_USERS_RECIPIENT);
			
			try
			{
				ps.setInt(1, recipId);
				
				ResultSet rs = ps.executeQuery();
				
				try
				{
					while(rs.next())
					{
						String personId = rs.getString("PersonId");
						String fName = rs.getString("FirstName");
						String lName = rs.getString("LastName");
						String email = rs.getString("EmailAddress");
						String giftListID = rs.getString("GiftListId");
						
						this.recip.add(new Person(personId, fName, lName, email, "", "", "", giftListID));
						
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

	public Vector<Person> getRecip() {
		return recip;
	}
	
}
