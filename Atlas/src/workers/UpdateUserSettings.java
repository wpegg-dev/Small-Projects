package workers;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import common.Queries;
import dbconnection.LocalDatabaseConnection;

public class UpdateUserSettings implements Runnable, Serializable {

	private static final long serialVersionUID = -3526887811618715249L;
	
	private String personId;
	private String firstName;
	private String lastName;
	private String emailAddress;
	private String updateMethod;
	private String password = "";
	private String hashedPassword;

	public UpdateUserSettings(String personId, String firstName,
			String lastName, String emailAddress, String updateMethod) {
		super();
		this.personId = personId;
		this.firstName = firstName;
		this.lastName = lastName;
		this.emailAddress = emailAddress;
		this.updateMethod = updateMethod;
	}
	
	public UpdateUserSettings(String personId, String firstName,
			String lastName, String emailAddress, String updateMethod, String password) {
		super();
		this.personId = personId;
		this.firstName = firstName;
		this.lastName = lastName;
		this.emailAddress = emailAddress;
		this.updateMethod = updateMethod;
		this.password = password;
	}

	@Override
	public void run() {
		//TODO: need to fix this
		if(("").equals(this.password))
		{
			this.updateAccount();
		}
		else
		{
			this.HashPassword();
			this.updateAccount();
		}
		
	}
	
	private void HashPassword()
	{
		String newPass = "";
		
		for(int i=0; i<password.length();i++)
		{
			char curChar = password.charAt(i);
			newPass = newPass + Character.toString((char)((int)curChar +1));
		}
		hashedPassword = newPass;
	}
	
	private void updateAccount()
	{
		if(updateMethod.equals("updateNoPass"))
		{
			LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
			
			Connection conn = lDbCon.getConnection();
			try 
			{
				PreparedStatement ps = conn.prepareStatement(Queries.UPDATE_USER_SETTINGS);
				
				try
				{
					
					ps.setString(1, firstName);
					ps.setString(2, lastName);
					ps.setString(3, emailAddress);
					ps.setString(4, personId);
					
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
		else
		{
			LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
			
			Connection conn = lDbCon.getConnection();
			try 
			{
				PreparedStatement ps = conn.prepareStatement(Queries.UPDATE_USER_SETTINGS_WITH_PASSWORD);
				
				try
				{
					
					ps.setString(1, firstName);
					ps.setString(2, lastName);
					ps.setString(3, emailAddress);
					ps.setString(4, hashedPassword);
					ps.setString(5, personId);
					
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

}
