package workers;

import java.io.IOException;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import common.Queries;
import dbconnection.LocalDatabaseConnection;

public class CreateUserAccount implements Runnable, Serializable {

	private static final long serialVersionUID = -6922167758621118889L;
	
	private String email;
	private String fName;
	private String lName;
	private String pass;
	private String hashedPass;
	private Integer accountExists;

	public CreateUserAccount(String fName, String lName, String email,  
			String pass) {
		super();
		this.email = email;
		this.fName = fName;
		this.lName = lName;
		this.pass = pass;
		this.accountExists = -1;
		this.hashedPass = "";
	}

	@Override
	public void run() {
		HashPassword();
		
		try {
			CreateAccount();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private void HashPassword()
	{
		String newPass = "";
		
		for(int i=0; i<pass.length();i++)
		{
			char curChar = pass.charAt(i);
			newPass = newPass + Character.toString((char)((int)curChar +1));
		}
		hashedPass = newPass;
	}
	
	private void CreateAccount() throws IOException
	{
		LocalDatabaseConnection lDbCon = new LocalDatabaseConnection();
		
		Connection conn = lDbCon.getConnection();
		try 
		{
			PreparedStatement ps = conn.prepareStatement(Queries.CREATE_USER_ACCOUNT);
			
			try
			{
				
				ps.setString(1, fName);
				ps.setString(2, lName);
				ps.setString(3, email);
				ps.setString(4, hashedPass);
				
				ps.execute();
				accountExists = ps.getUpdateCount();
				
			}
			finally
			{
				ps.close();
			}
			
		} 
		catch (SQLException e) 
		{
			e.printStackTrace();
			lDbCon.closeConnection();
		}
		finally
		{
			lDbCon.closeConnection();
		}
	}
	
	public Integer getAccountExists() {
		return accountExists;
	}

}
