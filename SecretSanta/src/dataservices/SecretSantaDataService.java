package dataservices;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.util.StringHelper;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import resources.GiftData;
import resources.Person;
import resources.PersonAndRecipient;
import workers.AddMyGift;
import workers.GatherAllRecipients;
import workers.GatherRecipientGiftList;
import workers.GetRecipient;
import workers.RemoveMyGift;

/**
 * Servlet implementation class SecretSantaDataService
 */
@WebServlet("/SecretSantaDataService")
public class SecretSantaDataService extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SecretSantaDataService() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@SuppressWarnings("unchecked")
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json");
		PrintWriter pw = response.getWriter();
		
		if(("getRecipient").equals(request.getParameter("method")))
		{
			if(StringHelper.isNotEmpty(request.getParameter("personId")))
			{
				
				String personId = request.getParameter("personId");
				
				GetRecipient gr = new GetRecipient(personId);
				
				Thread grt = new Thread(gr);
				
				grt.run();
				
				waitForThread(grt);

				JSONObject output = new JSONObject();
				JSONArray userData = new JSONArray();
				
				Iterator<Person> userIterator = gr.getRecip().iterator();
				while(userIterator.hasNext())
				{
					userData.add(userIterator.next());

				}
				
				output.put("recipientData", userData);
				pw.println(output.toJSONString());
			}
		}
		else if(("getList").equals(request.getParameter("method")))
		{
			if(StringHelper.isNotEmpty(request.getParameter("personId")))
			{
				
				String personId = request.getParameter("personId");
				
				GatherRecipientGiftList grgl = new GatherRecipientGiftList(personId);
				
				Thread grglt = new Thread(grgl);
				
				grglt.run();
				
				waitForThread(grglt);

				JSONObject output = new JSONObject();
				JSONArray giftData = new JSONArray();
				
				Iterator<GiftData> gifIterator = grgl.getGiftList().iterator();
				while(gifIterator.hasNext())
				{
					giftData.add(gifIterator.next());

				}
				
				output.put("giftListData", giftData);
				pw.println(output.toJSONString());
			}
		}
		else if(("getMyList").equals(request.getParameter("method")))
		{
			if(StringHelper.isNotEmpty(request.getParameter("personId")))
			{
				
				String personId = request.getParameter("personId");
				
				GatherRecipientGiftList grgl = new GatherRecipientGiftList(personId);
				
				Thread grglt = new Thread(grgl);
				
				grglt.run();
				
				waitForThread(grglt);

				JSONObject output = new JSONObject();
				JSONArray giftData = new JSONArray();
				
				Iterator<GiftData> gifIterator = grgl.getGiftList().iterator();
				while(gifIterator.hasNext())
				{
					giftData.add(gifIterator.next());

				}
				
				output.put("MygiftListData", giftData);
				pw.println(output.toJSONString());
			}
		}
		else if(("removeGift").equals(request.getParameter("method")))
		{
			if(StringHelper.isNotEmpty(request.getParameter("giftId")) && 
					StringHelper.isNotEmpty(request.getParameter("personId")))
			{
				
				String giftId = request.getParameter("giftId");
				String personId = request.getParameter("personId");
				
				RemoveMyGift rmg = new RemoveMyGift(giftId, personId);
				
				Thread rmgt = new Thread(rmg);
				rmgt.run();
				waitForThread(rmgt);
				

				JSONObject output = new JSONObject();
				/*JSONArray giftData = new JSONArray();
				
				Iterator<GiftData> gifIterator = grgl.getGiftList().iterator();
				while(gifIterator.hasNext())
				{
					giftData.add(gifIterator.next());

				}*/
				
				output.put("giftListData", "success");
				pw.println(output.toJSONString());
			}
		}
		else if(("addGift").equals(request.getParameter("method")))
		{
			if(StringHelper.isNotEmpty(request.getParameter("giftName")) && 
					StringHelper.isNotEmpty(request.getParameter("giftDescr")) &&
					StringHelper.isNotEmpty(request.getParameter("giftUrl")) &&
					StringHelper.isNotEmpty(request.getParameter("personId")))
			{
				
				String giftName = request.getParameter("giftName");
				String giftDescr = request.getParameter("giftDescr");
				String giftUrl = request.getParameter("giftUrl");
				String personId = request.getParameter("personId");
				
				AddMyGift amg = new AddMyGift(giftName, giftDescr, giftUrl, personId);
				
				Thread amgt = new Thread(amg);
				amgt.run();
				waitForThread(amgt);
				

				JSONObject output = new JSONObject();
				/*JSONArray giftData = new JSONArray();
				
				Iterator<GiftData> gifIterator = grgl.getGiftList().iterator();
				while(gifIterator.hasNext())
				{
					giftData.add(gifIterator.next());

				}*/
				
				output.put("giftListData", "success");
				pw.println(output.toJSONString());
			}
		}
		else if(("getAllRecipients").equals(request.getParameter("method")))
		{
			GatherAllRecipients gar = new GatherAllRecipients();
			
			Thread agar = new Thread(gar);
			agar.run();
			waitForThread(agar);
			

			JSONObject output = new JSONObject();
			JSONArray recipData = new JSONArray();
			
			Iterator<PersonAndRecipient> fullListIterator = gar.getRecip().iterator();
			while(fullListIterator.hasNext())
			{
				recipData.add(fullListIterator.next());

			}
			
			output.put("FullRecipList", recipData);
			pw.println(output.toJSONString());
		}
	}
	
	private void waitForThread(Thread thread)
	{
		if(thread.isAlive())
		{
			try
			{
				thread.join();
			}
			catch(InterruptedException e)
			{
				System.out.println("Thread Interrupted: "+e.getMessage());
			}
		}
	}	

}
