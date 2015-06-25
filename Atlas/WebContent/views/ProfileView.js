(function($) {
	var methods = {
			"init": function(options){
				$.extend( $.profile.global, options );
				return this.each(function(){
					$.profile.create();
				});
			}
		};

	/* *****************************
	 * 
	 * create namespace
	 *
	 ******************************/
	$.profile = {};
	
	/* *********************************
	 * 
	 *  create global variables
	 *
	 * *********************************/
	$.profile.global = {
		"emailAddress": null,
		"FullName": null,
		"accountType": null,
		"PersonId": null,
		"currentRequest": null
		
	};
	
	/* ************************************
	 * 
	 *  declare method to build view from jsp
	 * 
	 * ************************************/
	$.fn.ProfileView = function( method ) {	    
		
		if($.session.get("authorized") === "False")
		{
			
			buildLandingPage();
		}
		else
		{
			// Method calling logic
			if ( methods[method] ) {
				return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
			} else if ( typeof method === 'object' || ! method ) {
				return methods.init.apply( this, arguments );
			} else {
				alert($.error( 'Method ' +  method + ' does not exist on jQuery.dialogPrompt' ));
				$.error( 'Method ' +  method + ' does not exist on jQuery.dialogPrompt' );
			}
		}
	};
	
	/* **********************************
	 * 
	 *  create destroy function
	 * 
	 * **********************************/
	$.profile.destroy = function(){
		if($.profile.global.currentRequest!==null)
		{
			$.profile.global.currentRequest.abort();
		}
		
		if($.profile.global.container !== null)
		{
			$.profile.global.container.remove();
		}
		
		$('#mainBody').ProfileView("destroy");
	};
	
	/* **********************************
	 * 
	 *  create create function
	 * 
	 * **********************************/
	$.profile.create = function()
	{
		$.profile.global.containingDiv = $('<div/>').attr('id','userProfile');
		//readSession();
		$.profile.buildView();
	};
	
	/* ************************************
	 * 			BUILD VIEW  
	 * ************************************/
	$.profile.buildView = function()
	{	
		$('body').attr({'style':'background:#ffffff;margin:0px;'});
		$('#mainBody').attr({'style':'width: 100%;height: 100%;background: #fff;overflow:hidden;'});
		$('#footer').attr({'style':'background: #252525;width: 100%;height: 40px;margin: 0 auto;color: #a6a6a6;text-align: center;font-size: 16px;font-family: GillSans;'});
		
		$.profile.destroyPrevPages();
		
		$('#welcome')
			.append(
				$('<div/>')
					.attr('id','userHeader')
					.append(
						$('<ul/>')
							.attr('id','userNav')
							.append(
								$('<li/>')
									.append(
										$('<label/>')
											.text('Welcome '+$.profile.global.FullName)
									)
							)
							.append(
								$('<li/>')
									.append(
										$('<label/>')
											.text('Account')
											.click(function(){
												$.profile.buildSettingsView();
											})
									)
							)
							.append(
								$('<li/>')
									.append(
										$('<label/>')
											.text('Sign Off')
											.click(function(){
												//$.session.remove("authorized");
												setSession("False");
												$.session.set("userEmail","");
												$.session.set("userPass","");
												$.session.set("userId","");
												$.session.set("accessLevel","");
												$('#appLoader').hide();
												location.reload();
												//buildLandingPage();
											})
									)
							)
					)
			);
		
		$('#appLoader')
			.before(
				$('<div/>')
					.attr('id','siteNav')
					.append(
							$('<ul/>')
							.addClass('topnav')
							/*.append(
								$('<li/>')
									.append(
										$('<label/>')
											.text('Home')
											.click(function(){
												$.profile.buildView();
											})
									)
							)*/
							.append(
								$('<li/>')
									.addClass('appsLink')
									.append(
										$('<label/>')
											.text('Applications')
									)
									.append(
										$('<ul/>')
											.addClass('subnav')
											.append(
												$('<li/>')
													.append(
														$('<label/>')
															.text('Secret Santa')
															.click(function(event){
														       event.preventDefault();
														       $('#appLoader').html('<object id="siteLoader" data="http://76.17.8.24:8080/SecretSanta/index.jsp"/>');
														       //$('#appLoader').html('<object id="siteLoader" data="http://localhost:8080/SecretSanta/index.jsp"/>');
														})
													)
											)
											//put other apps here
									)
							)
							.append(
								$('<li/>')
									.append(
										$('<label/>')
											.text('Submit Idea')
											.click(function(){
												$.profile.submitIdea();
											})
									)
							)
							.append(
								$('<li/>')
									.append(
										$('<label/>')
											.text('Contact Us')
											.click(function(){
												$.profile.sendCommunication();
											})
									)
							)
					)
			);
		
		$('#appLoader').show();
		
		//$("ul.subnav").parent().append("<span style=\"margin-top:10px;\"><img src=\"\"></img></span>"); //Only shows drop down trigger when js is enabled (Adds empty span tag after ul.subnav*)
		
		$(".appsLink").mouseenter(function() { //When trigger is clicked...
			
			//Following events are applied to the subnav itself (moving subnav up and down)
			$(this).parent().find("ul.subnav").slideDown('fast').show(); //Drop down the subnav on click

			$(this).parent().hover(function() {
			}, function(){	
				$(this).parent().find("ul.subnav").slideUp('slow'); //When the mouse hovers out of the subnav, move it back up
			});

			//Following events are applied to the trigger (Hover events for the trigger)
			}).hover(function() { 
				$(this).addClass("subhover"); //On hover over, add class "subhover"
			}, function(){	//On Hover Out
				$(this).removeClass("subhover"); //On hover out, remove class "subhover"
		});
		
		
		
	};
	
	
	$.profile.destroyPrevPages = function(){
		$('#leftMain').remove();
		$('#rightMain').remove();
		//$('#appLoader').remove();
		$('#userHeader').remove();
		$('#siteNav').remove();
	};
	
	$.profile.buildSettingsView = function(){
		$('#mainBody')
			.append(
				$('<div/>')
					.attr({'id':'UserAccountSettings'})
					.append(
						$('<div/>')
							.attr('id','settingsForm')
							.append(
								$('<table/>')
									.append(
										$('<tr/>')
											.append(
												$('<td/>')
													.append(
														$('<label/>')
															.text('First Name: ')
													)
											)
											.append(
												$('<td/>')
													.append(
														$('<input/>')
															.attr({'id':'fNameInput','type':'text','readonly':'readonly'})
															.val($.profile.global.FirstName)
															.click(function(){
																//toggle readonly attribute on field
																$(this).removeAttr('readonly');
																$(this).css({'color':'#000000'});
															})
													)
											)
									)
									.append(
										$('<tr/>')
											.append(
												$('<td/>')
													.append(
														$('<label/>')
															.text('Last Name: ')
													)
											)
											.append(
												$('<td/>')
													.append(
														$('<input/>')
															.attr({'id':'lNameInput','type':'text','readonly':'readonly'})
															.val($.profile.global.LastName)
															.click(function(){
																//toggle readonly attribute on field
																$(this).removeAttr('readonly');
																$(this).css({'color':'#000000'});
															})
													)
											)
									)
									.append(
										$('<tr/>')
											.append(
												$('<td/>')
													.append(
														$('<label/>')
															.text('Email Address: ')
													)
											)
											.append(
												$('<td/>')
													.append(
														$('<input/>')
															.attr({'id':'emailAddInput','type':'text','readonly':'readonly'})
															.val($.profile.global.emailAddress)
															.click(function(){
																//toggle readonly attribute on field
																$(this).removeAttr('readonly');
																$(this).css({'color':'#000000'});
															})
													)
											)
									)
									.append(
										$('<tr/>')
											.append(
												$('<td/>')
													.append(
														$('<label/>')
															.text('Password: ')
													)
											)
											.append(
												$('<td/>')
													.append(
														$('<input/>')
															.attr({'id':'passwordInput','type':'password','readonly':'readonly'})
															.click(function(){
																//toggle readonly attribute on field
																$(this).removeAttr('readonly');
																$(this).css({'color':'#000000'});
															})
													)
											)
									)
									.append(
										$('<tr/>')
											.append(
												$('<td/>')
													.append(
														$('<label/>')
															.text('Re-Enter Password: ')
													)
											)
											.append(
												$('<td/>')
													.append(
														$('<input/>')
															.attr({'id':'rePasswordInput','type':'password','readonly':'readonly'})
															.click(function(){
																//toggle readonly attribute on field
																$(this).removeAttr('readonly');
																$(this).css({'color':'#000000'});
															})
													)
											)
									)
									.append(
										$('<tr/>')
											.append(
												$('<td/>')
											)
											.append(
												$('<td/>')
													.append(
														$('<input/>')
															.addClass('IndexLoginButton')
															.attr({'id':'updateAccountButton','type':'submit'})
															.val('Update Account')
															.click(function(){
																//verify that information input is allowed
																var _newFName = $('#fNameInput').val();
																var _newLName = $('#lNameInput').val();
																var _newEmail = $('#emailAddInput').val();
																var _newPass = $('#passwordInput').val();
																var _newPassCheck = $('#rePasswordInput').val();
																
																if(_newFName == '')
																{
																	alert('Please Enter Your First Name.');
																}
																else if(_newLName == '')
																{
																	alert('Please Enter Your Last Name.');
																}
																else if(_newEmail == '')
																{
																	alert('Please Enter Your Email Address.');
																}
																else if(_newPass != '' || _newPassCheck != '')
																{
																	if(_newPass === _newPassCheck)
																	{
																		//if new password matches new password check and is not null updated account
																		$.profile.updateSettingsWithPassword(_newFName,_newLName,_newEmail,_newPass,_newPassCheck);
																	}
																	else
																	{
																		alert('New Passwords do not match. Please Try again');
																	}
																}
																else
																{
																	//update users account assuming that the password is not being updated
																	$.profile.updateSettings(_newFName,_newLName,_newEmail);
																}
															})
													)
											)
									)
							)
					)
			);
		
		
		$('#settingsForm').dialog({
			'height': '300',
			'width': '300',
			'modal':'false',
			'closeOnEscape': 'true',
            'resizable': 'false',
            'close': function(ev, ui) { 
            	//rebuild groups after new group created
            	$.profile.buildView();
            	$(this).remove();
            }
		});
		
	};
	
	
	$.profile.updateSettings = function(_newFName,_newLName,_newEmail){
		$.profile.global.currentRequest = 
			$.ajax({ 
		  	  	url:"/Atlas/UserSettingsDataService",
		  	  	data:{
		  	  		"personId": $.profile.global.PersonId,
		  	  		"firstName":_newFName,
		  	  		"lastName":_newLName,
		  	  		"emailAddress":_newEmail,
		  	  		"method":"updateNoPass"
		  	  	},
				type:'POST',
				dataType:"json",
				success: function(html){
					$('#globalSettings').data('userData',html);
					$.profile.global.FullName = html['userData'][0]['First Name']+' '+html['userData'][0]['Last Name'];
					$.profile.global.FirstName = html['userData'][0]['First Name'];
					$.profile.global.LastName = html['userData'][0]['Last Name'];
					$.profile.global.emailAddress = html['userData'][0]['Email Address'];
					$.profile.global.accessLevel = html['userData'][0]['User Type'];
					$.session.set("accessLevel",html['userData'][0]['User Type']);
					alert("Account Updated Successfully!");
					$('#settingsForm').dialog('destroy').remove();
					$.profile.buildView();
				},
				error: function(html){
					alert("An error occured while gathering profile information." +
							"\nPlease refresh your browser and try again.");
				}
			}); //Closes ajax
	};
	
	/* *****************************************
	 * 
	 *  function to update users info including 
	 *  password from settings menu
	 * 
	 * *****************************************/
	$.profile.updateSettingsWithPassword = function(_newFName,_newLName,_newEmail,_newPass,_newPassCheck){
		$.profile.global.currentRequest = 
			$.ajax({ 
		  	  	url:"/Atlas/UserSettingsDataService",
		  	  	data:{
		  	  		"personId": $.profile.global.PersonId,
		  	  		"firstName":_newFName,
		  	  		"lastName":_newLName,
		  	  		"emailAddress":_newEmail,
		  	  		"password":_newPass,
		  	  		"method":"updateWithPass"
		  	  	},
				type:'POST',
				dataType:"json",
				success: function(html){
					$('#globalSettings').data('userData',html);
					$.profile.global.FullName = html['userData'][0]['First Name']+' '+html['userData'][0]['Last Name'];
					$.profile.global.FirstName = html['userData'][0]['First Name'];
					$.profile.global.LastName = html['userData'][0]['Last Name'];
					$.profile.global.emailAddress = html['userData'][0]['Email Address'];
					$.profile.global.accessLevel = html['userData'][0]['User Type'];
					$.session.set("accessLevel",html['userData'][0]['User Type']);
					alert("Account Updated Successfully!");
					$('#settingsForm').dialog('destroy').remove();
					$.profile.buildView();
				},
				error: function(html){
					alert("An error occured while gathering profile information." +
							"\nPlease refresh your browser and try again.");
				}
			}); //Closes ajax
	};
	
	/* ***************************************************
	 * 
	 *  Function to beuild email to send to admin
	 * 
	 * ***************************************************/
	$.profile.sendCommunication = function(){
		$('#mainBody')
			.append(
				$('<div/>')
					.attr({'id':'contactUsDiv'})
					.append(
						$('<div/>')
							.attr({'id':'contactUsForm'})
							.append(
								$('<table/>')
									.attr({'id':'contactTable'})
									.append(
										$('<tr/>')
											.append(
												$('<td/>')
													.append(
														$('<label/>')
															.attr({'id':'from'})
															.text('From:')
													)
											)
											.append(
												$('<td/>')
													.append(
														$('<input/>')
															.attr({'id':'fromInput','readonly':'readonly','style':'background:#aaaaaa;width:426px;'})
															.val($.profile.global.FullName)
													)
											)
									)
									.append(
										$('<tr/>')
											.append(
												$('<td/>')
													.append(
														$('<label/>')
															.attr({'id':'title'})
															.text('Title:')
													)
											)
											.append(
												$('<td/>')
													.append(
														$('<input/>')
															.attr({'id':'titleInput','style':'width:426px;'})
													)
											)
									)
									.append(
										$('<tr/>')
											.append(
												$('<td/>')
													.append(
														$('<label/>')
															.attr({'id':'body'})
															.text('Body:')
													)
											)
											.append(
												$('<td/>')
													.append(
														$('<textarea/>')
															.attr({'id':'bodyInput','rows':'15','cols':'45'})
													)
											)
									)
									.append(
										$('<tr/>')
											.append(
												$('<td/>')
											)
											.append(
												$('<td/>')
													.append(
														$('<button/>')
															.attr({'id':'submitContact','style':'float:right;'})
															.text('Send!')
															.click(function(){
																$.profile.sendContactUs();
															})
													)
											)
									)
							)
					)
			);
		
		$('#contactUsForm').dialog({
			'height': '525',
			'width': '600',
			'modal':'false',
			'closeOnEscape': 'true',
            'resizable': 'false',
            'close': function(ev, ui) { 
            	//rebuild groups after new group created
            	$.profile.buildView();
            	$(this).remove();
            }
		});
	};
	
	/* ************************************************
	 * 
	 *   Function to build idea submission form
	 * 
	 * ************************************************/
	$.profile.submitIdea = function(){
		$('#mainBody')
			.append(
				$('<div/>')
					.attr({'id':'newIdeaDiv'})
					.append(
						$('<div/>')
							.attr({'id':'newIdeaForm'})
							.append(
								$('<table/>')
									.attr({'id':'ideaTable'})
									.append(
										$('<tr/>')
											.append(
												$('<td/>')
													.append(
														$('<label/>')
															.attr({'id':'ideaTitle'})
															.text('Idea Title:')
													)
											)
											.append(
												$('<td/>')
													.append(
														$('<input/>')
															.attr({'id':'ideaTitleText','type':'text'})
													)
											)
									)
									.append(
										$('<tr/>')
											.append(
												$('<td/>')
													.append(
														$('<label/>')
															.attr({'id':'ideaDescription'})
															.text('Idea Description:')
													)
											)
											.append(
												$('<td/>')
													.append(
														$('<textarea/>')
															.attr({'id':'ideaDescrText','cols':'45','rows':'15'})
													)
											)
									)
									.append(
										$('<tr/>')
											.append(
												$('<td/>')
											)
											.append(
												$('<td/>')
													.append(
														$('<button/>')
															.attr({'id':'submitIdea'})
															.text('Submit Idea')
															.click(function(){
																$.profile.SendIdea();
															})
													)
											)
									)
							)
					)
			);
		
		$('#newIdeaForm').dialog({
			'height': '500',
			'width': '600',
			'modal':'false',
			'closeOnEscape': 'true',
            'resizable': 'false',
            'close': function(ev, ui) { 
            	//rebuild groups after new group created
            	$.profile.buildView();
            	$(this).remove();
            }
		});
	};
	
	$.profile.sendContactUs = function(){
		var _from = $('#fromInput').val(); 
		var _title = $('#titleInput').val();
		var _body = $('#bodyInput').val();
		
		//alert(_from+' '+_title+' '+_body);
		if(_title === '')
		{
			alert('Please Enter A Title.');
		}
		else if(_body === '')
		{
			alert('Please Enter Your Question/Comment/Concern.');
		}
		else
		{
			$.ajax({ 
		  	  	url:"/Atlas/CommonServicesDataService",
		  	  	data:{
		  	  		"title":_title,
		  	  		"descr":_body,
		  	  		"Name":_from,
		  	  		"emailAddress":$.profile.global.emailAddress,
		  	  		"method":"sendQuestion"
		  	  	},
				type:'POST',
				dataType:"json",
				success: function(html){
					alert("Thanks! We'll Get Back To You As Soon AS We Can.");
					$('#contactUsForm').dialog('destroy').remove();
					$.profile.buildView();
				},
				error: function(html){
					alert("An error occured while submitting question." +
							"\nPlease refresh your browser and try again.");
				}
			}); //Closes ajax
		}
		
	};
	
	$.profile.SendIdea = function(){
		var _title = $('#ideaTitleText').val();
		var _descr = $('#ideaDescrText').val();
		
		//alert(_title+' '+_descr);
		$.ajax({ 
	  	  	url:"/Atlas/CommonServicesDataService",
	  	  	data:{
	  	  		"title":_title,
	  	  		"descr":_descr,
	  	  		"Name":$.profile.global.FullName,
	  	  		"emailAddress":$.profile.global.emailAddress,
	  	  		"method":"sendIdea"
	  	  	},
			type:'POST',
			dataType:"json",
			success: function(html){
				alert("Thank You For Your Idea!");
				$('#newIdeaForm').dialog('destroy').remove();
				$.profile.buildView();
			},
			error: function(html){
				alert("An error occured while submitting idea." +
						"\nPlease refresh your browser and try again.");
			}
		}); //Closes ajax
	};
	
})(jQuery);