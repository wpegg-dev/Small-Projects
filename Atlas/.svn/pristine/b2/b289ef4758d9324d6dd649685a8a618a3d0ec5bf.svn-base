package dataservices;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.util.StringHelper;
import org.json.simple.JSONObject;

/**
 * Servlet implementation class CommonServicesDataService
 */
@WebServlet("/CommonServicesDataService")
public class CommonServicesDataService extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CommonServicesDataService() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@SuppressWarnings("unchecked")
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json");
		PrintWriter pw = response.getWriter();
		
		if(("sendIdea").equals(request.getParameter("method")))
		{
			if(StringHelper.isNotEmpty(request.getParameter("title")) &&
					StringHelper.isNotEmpty(request.getParameter("descr")) &&
					StringHelper.isNotEmpty(request.getParameter("Name")) &&
					StringHelper.isNotEmpty(request.getParameter("emailAddress")))
			{
				String title = request.getParameter("title");
				String Descr = request.getParameter("descr");
				String name = request.getParameter("Name");
				String email = request.getParameter("emailAddress");
				
				Properties props = new Properties();
				props.put("mail.smtp.host", "smtp.gmail.com");
				props.put("mail.smtp.socketFactory.port", "465");
				props.put("mail.smtp.socketFactory.class",
						"javax.net.ssl.SSLSocketFactory");
				props.put("mail.smtp.auth", "true");
				props.put("mail.smtp.port", "465");
		 
				Session session = Session.getDefaultInstance(props,
					new javax.mail.Authenticator() {
						protected PasswordAuthentication getPasswordAuthentication() {
							return new PasswordAuthentication("pegg.server","P3Gg53rv3R");
						}
					});
		 
				try {
		 
					JSONObject output = new JSONObject();
					
					Message message = new MimeMessage(session);
					message.setFrom(new InternetAddress("pegg.server@gmail.com"));
					message.setRecipients(Message.RecipientType.TO,
							InternetAddress.parse("pegg.server@gmail.com"));
					message.setSubject("New Web Application Submission");
					message.setText("Dear Server Administrator," +
							"\n\n A new idea has been created for your server!"
							+ "\n\n"+name+" submitted a new idea."
							+ "\n Title: "+title+""
							+ "\n Description: "+Descr+""
							+ "\n Contact: "+email);
		 
					Transport.send(message);
		 
					output.put("message", "success");
					pw.println(output.toJSONString());
		 
				} catch (MessagingException e) {
					throw new RuntimeException(e);
				}
				
				
			}
		}
		else if(("sendQuestion").equals(request.getParameter("method")))
		{
			if(StringHelper.isNotEmpty(request.getParameter("title")) &&
					StringHelper.isNotEmpty(request.getParameter("descr")) &&
					StringHelper.isNotEmpty(request.getParameter("Name")) &&
					StringHelper.isNotEmpty(request.getParameter("emailAddress")))
			{
				String title = request.getParameter("title");
				String Descr = request.getParameter("descr");
				String name = request.getParameter("Name");
				String email = request.getParameter("emailAddress");
				
				Properties props = new Properties();
				props.put("mail.smtp.host", "smtp.gmail.com");
				props.put("mail.smtp.socketFactory.port", "465");
				props.put("mail.smtp.socketFactory.class",
						"javax.net.ssl.SSLSocketFactory");
				props.put("mail.smtp.auth", "true");
				props.put("mail.smtp.port", "465");
		 
				Session session = Session.getDefaultInstance(props,
					new javax.mail.Authenticator() {
						protected PasswordAuthentication getPasswordAuthentication() {
							return new PasswordAuthentication("pegg.server","P3Gg53rv3R");
						}
					});
		 
				try {
		 
					JSONObject output = new JSONObject();
					
					Message message = new MimeMessage(session);
					message.setFrom(new InternetAddress(email));
					message.setRecipients(Message.RecipientType.TO,
							InternetAddress.parse("pegg.server@gmail.com"));
					message.setSubject("New Atlas Question: "+title);
					message.setText("Dear Server Administrator,"
							+ "\n\n"+name+" submitted a new question."
							+ "\n Title: "+title+""
							+ "\n Description: "+Descr+""
							+ "\n Contact: "+email);
		 
					Transport.send(message);
		 
					output.put("message", "success");
					pw.println(output.toJSONString());
		 
				} catch (MessagingException e) {
					throw new RuntimeException(e);
				}
				
				
			}
		}
	}
	
}
