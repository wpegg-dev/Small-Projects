package dbconnection;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;


public class LocalDatabaseConnection {

	private static Logger log = Logger.getLogger("LocalDatabaseConnection");
	Connection con;

	public LocalDatabaseConnection()
	{
		try
		{
			String SQLDrive = "com.mysql.jdbc.Driver";
			String SQLURL = "jdbc:mysql://localhost:3306/atlas";
			String user = "";
			String password = "";
			
			
			Class.forName(SQLDrive).newInstance();
			con = DriverManager.getConnection(SQLURL,user,password);
		}
		catch (SQLException e)
		{
			
			
			System.out.println("SQL Error:" + e);
			log.log(Level.SEVERE,"SQL Error:" + e);
			
			try {
			    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter("/opt/tomcat/errors.txt", true)));
			    out.println("SQL Error: " + e);
			    out.close();
			} catch (IOException e1) {
			    //oh noes!
			}
			
		}
		catch (Exception e)
		{
			System.out.println("Failed to load MySQL Driver" + e);
			log.log(Level.SEVERE,"Failed to load MySQL Driver" + e);
			try {
			    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter("/opt/tomcat/errors.txt", true)));
			    out.println("Failed to load MySQL Driver" + e);
			    out.close();
			} catch (IOException e1) {
			    //oh noes!
			}
		}
	}
	
	public Connection getConnection()
	{
		return this.con;
	}
	
	public void closeConnection()
	{
		try
		{
			if(this.con != null)
			{
				this.con.close();
			}
		}
		catch (SQLException e)
		{
			SQLException e1 = ((SQLException)e).getNextException();
			if (e1 != null)
				System.out.println("SQL Error:" + e1);
			log.log(Level.SEVERE,"SQL Error:" + e1);
		}
	}
}