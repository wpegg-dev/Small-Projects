package workers;

import java.io.Serializable;
import java.util.Vector;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import common.Queries;
import dbconnection.LocalDatabaseConnection;
import resources.UserData;

public class GetUserData implements Serializable, Runnable {

	private static final long serialVersionUID = 3846125539514093611L;
	
	private String email;
	private String pass;
	private String hashedPass;
	private Vector<UserData> user;

	public GetUserData(String email, String pass) {
		super();
		this.email = email;
		this.pass = pass;
		this.user = new Vector<UserData>();
	}

	@Override
	public void run() {
		getHasedPassword();
		getUsersData();
	}
	
	private void getHasedPassword()
	{
		String newPass = "";
		
		for(int i=0; i<pass.length();i++)
		{
			char curChar = pass.charAt(i);
			newPass = newPass + Character.toString((char)((int)curChar +1));
		}
		
		hashedPass = newPass;
	}
	
	private void getUsersData()
	{
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		
		Connection conn = lDbCon.getConnection();
		try 
		{
			PreparedStatement ps = conn.prepareStatement(Queries.LOGIN_GATHER_ACCOUNT_DATA);
			
			try
			{
				ps.setString(1, email);
				ps.setString(2, hashedPass);
				
				ResultSet rs = ps.executeQuery();
				
				try
				{
					while(rs.next())
					{
						String personId = rs.getString("PersonID");
						String fName = rs.getString("FirstName");
						String lName = rs.getString("LastName");
						String emailAdd = rs.getString("EmailAdd");
						String userType = rs.getString("Type");
						
						this.user.add(new UserData(personId, fName, lName, emailAdd, userType));
						
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
	
	public Vector<UserData> getUserInfo()
	{
		return user;
	}

}
