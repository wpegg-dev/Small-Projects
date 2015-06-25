<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>

	<meta name="viewport" content="width=1024" />
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
	
	<title>Atlas</title>
	
	<link rel="stylesheet" type="text/css" href="styles/index.css">
	<link rel="stylesheet" type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/themes/ui-lightness/jquery-ui.min.css"> 
	<link rel="stylesheet" type="text/css" href="styles/jqueryUi.css">
	
	<!-- GET jQuery Libraries -->
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	<!-- <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"></script> -->
	<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.js"></script>
	
	<script src="plugins/jquery.session.js"></script>
	<script src="views/ProfileView.js"></script>
	<script  src="plugins/css_browser_selector.js" type="text/javascript"></script>

	<style type="text/css">
	.ie #userHeader {
		width: 400px;
		padding-top: 6.5px;
		float: right;
		height: 30px;
	}
	.chrome #userHeader {
		width: 345px;
		padding-top: 6.5px;
		float: right;
		height: 30px;
	}
	</style>

	<script type="text/javascript">
	
	$(document).ready(function(){				
		$('#processing')
			.hide()
			.append('<img src="images/loading.gif"/>')
			.ajaxStart(function(){
				$(this).show();
			})
			.ajaxStop(function(){
				$(this).hide();
			});
		
		if($.session.get("authorized") === "True")
		{
			userLoginAction();
			//$('#mainBody').ProfileView();//{'FullName':userData[0]['Full Name'],'FirstName':userData[0]['First Name'],'LastName':userData[0]['Last Name'],'PersonId':userData[0]['Person ID'],'emailAddress':userData[0]['Email Address'],'accountType':userData[0]['User Type']});//
		}
		else
		{
			
		
			setSession("False");
			buildLandingPage();
			
					
			/************************END MAIN*************************/
			
				if(!Array.prototype.filter) {
				    Array.prototype.filter = function (fun) {
				        "use strict";

				        if ((this === void(0)) || (this === null))
				        {
				            throw new TypeError();
				        }

				        var t = Object(this);
				        var len = t.length >>> 0;
				        if (typeof fun !== "function")
				            throw new TypeError();

				        var res = [];
				        var thisp = arguments[1];
				        for (var i = 0; i < len; i++) {
				            if (i in t) {
				                var val = t[i]; // in case fun mutates this
				                if (fun.call(thisp, val, i, t))
				                    res.push(val);
				            }
				        }

				        return res;
				    };
				}
		}
		
	});//Closes $(document).ready(
			
			function buildLandingPage()
			{
				$('#userHeader').remove();
				$('#UserAccountSettings').remove();
				$('#siteNav').remove();
				//$('#appLoader').remove();
				
				var _bodyContents = $('#mainBody');
				
				_bodyContents
					.append(
						$('<div/>')
						.attr({'id':'leftMain'})
						.append(
							$('<div/>')
							.attr({'id':'welcomeInfo'})
								.append(
									$('<h1/>')
										.addClass('firstWelcome')
										.text('Atlas')
									)
								.append(
									$('<span/>')
										.text('This is a site provided by Bill Pegg to help make your activities easier to manage and help you stay organized.')
									)
							)
						)

						/**************************************************
						/
						/     Right div for login/sign-up
						/
						/**************************************************/
							.append(
								$('<div/>')
								.attr({'id':'rightMain'})
							//LOGIN
							.append(
								$('<div/>')
								.attr({'id':'login'})
									.append(
										$('<h3/>')
											.text('Login')
											)
									.append(
										$('<div/>')
										.attr({'id':'loginForm'})
											.append(
												$('<span/>')
													.text('Email Address')
													)
											.append(
												$('<input/>')
													.attr({'id':'unameField','type':'text'})
													)
											.append(
												$('<span/>')
													.text('Password')
													)
											.append(
												$('<input/>')
													.attr({'id':'pwordField','type':'password'})
													.keydown(function(event){
														
														if(event.keyCode === 13){
															event.preventDefault();
															event.stopPropagation();
															userLoginAction();
															return false;
														}
														else{
															this.focus();
														}
													})
													)
											.append(
												$('<input/>')
												.addClass('IndexLoginButton')
												.attr({'id':'loginButton','type':'submit'})
												.val('Login')
												.click(function(){
													userLoginAction();
												})
												)
										)
							)//END LOGIN
							//SIGN UP
							.append(
								$('<div/>')
								.attr({'id':'signup','style':'display:none;'})
									.append(
										$('<h3/>')
											.text('Or Sign-Up for Free!')
										)
									.append(
										$('<div/>')
										.attr({'id':'signupForm'})
											.append(
												$('<div/>')
												.attr({'id':'formText'})
													.append(
														$('<span/>')
														.text('First Name: ')
														)
													.append(
														$('<span/>')
														.text('Last Name: ')
														)
													.append(
														$('<span/>')
														.text('E-mail: ')
														)
													.append(
														$('<span/>')
														.text('Re-enter E-mail: ')
														)
													.append(
														$('<span/>')
														.text('Password: ')
														)
													.append(
														$('<span/>')
														.text('Re-enter Password: ')
														)
													)
											.append(
												$('<div/>')
												.attr({'id':'formData'})
													.append(
														$('<input/>')
														.attr({'id':'createFirst','type':'text'})
														)
													.append(
														$('<input/>')
														.attr({'id':'createLast','type':'text'})
														)
													.append(
														$('<input/>')
														.attr({'id':'createEmail','type':'text'})
														)
													.append(
														$('<input/>')
														.attr({'id':'createEmailCheck','type':'text'})
														)
													.append(
														$('<input/>')
														.attr({'id':'createPassword','type':'password'})
														)
													.append(
														$('<input/>')
														.attr({'id':'createPasswordCheck','type':'password'})
														)
													// SIGN UP FUNCTION
													.append(
														$('<input/>')
															.addClass('IndexLoginButton')
															.attr({'id':'signUpButton','type':'submit'})
															.val('Sign Up')
															.click(function(){
																
																var _fname = '';
																var _lname = '';
																var _email = '';
																var _emailCheck = '';
																var _pass = '';
																var _passCheck = '';
																
																if($('#createFirst').val() == '')
																{
																	alert('Please enter your first name.');
																	$('#createFirst').val('');
																	$('#createLast').val('');
																	$('#createEmail').val('');
																	$('#createEmailCheck').val('');
																	$('#createPassword').val('');
																	$('#createPasswordCheck').val('');
																}
																else if($('#createLast').val() == '')
																{
																	alert('Please enter your last name.');
																	$('#createFirst').val('');
																	$('#createLast').val('');
																	$('#createEmail').val('');
																	$('#createEmailCheck').val('');
																	$('#createPassword').val('');
																	$('#createPasswordCheck').val('');
																}
																else if($('#createEmail').val() == '')
																{
																	alert('Please enter an e-mail address.');
																	$('#createFirst').val('');
																	$('#createLast').val('');
																	$('#createEmail').val('');
																	$('#createEmailCheck').val('');
																	$('#createPassword').val('');
																	$('#createPasswordCheck').val('');
																}
																else if(($('#createEmail').val()).indexOf('@') <= 0)
																{
																	alert('Please enter an e-mail address.\n Email Address must contain an @ symbol');
																	$('#createFirst').val('');
																	$('#createLast').val('');
																	$('#createEmail').val('');
																	$('#createEmailCheck').val('');
																	$('#createPassword').val('');
																	$('#createPasswordCheck').val('');
																}
																else if(($('#createEmail').val()).indexOf('.com') <= 0 &&
																		($('#createEmail').val()).indexOf('.edu') <= 0 &&
																		($('#createEmail').val()).indexOf('.net') <= 0 &&
																		($('#createEmail').val()).indexOf('.org') <= 0 &&
																		($('#createEmail').val()).indexOf('.mail') <= 0)
																{
																	alert('Please enter an e-mail address.\n Email Address must end with .com, .gmail, .org, .net, .edu or .mail');
																	$('#createFirst').val('');
																	$('#createLast').val('');
																	$('#createEmail').val('');
																	$('#createEmailCheck').val('');
																	$('#createPassword').val('');
																	$('#createPasswordCheck').val('');
																}
																else if($('#createEmailCheck').val() == '')
																{
																	alert('Please enter an e-mail address.');
																	$('#createFirst').val('');
																	$('#createLast').val('');
																	$('#createEmail').val('');
																	$('#createEmailCheck').val('');
																	$('#createPassword').val('');
																	$('#createPasswordCheck').val('');
																}
																else if(($('#createEmailCheck').val()).indexOf('@') <= 0)
																{
																	alert('Please enter an e-mail address.\n Email Address must contain an @ symbol');
																	$('#createFirst').val('');
																	$('#createLast').val('');
																	$('#createEmail').val('');
																	$('#createEmailCheck').val('');
																	$('#createPassword').val('');
																	$('#createPasswordCheck').val('');
																}
																else if(($('#createEmailCheck').val()).indexOf('.com') <= 0 &&
																		($('#createEmailCheck').val()).indexOf('.edu') <= 0 &&
																		($('#createEmailCheck').val()).indexOf('.net') <= 0 &&
																		($('#createEmailCheck').val()).indexOf('.org') <= 0 &&
																		($('#createEmailCheck').val()).indexOf('.mail') <= 0)
																{
																	alert('Please enter an e-mail address.\n Email Address must end with .com, .gmail, .org, .net, .edu or .mail');
																	$('#createFirst').val('');
																	$('#createLast').val('');
																	$('#createEmail').val('');
																	$('#createEmailCheck').val('');
																	$('#createPassword').val('');
																	$('#createPasswordCheck').val('');
																}
																else if($('#createEmail').val() != $('#createEmailCheck').val())
																{
																	alert('Email addresses do not match.');
																	$('#createFirst').val('');
																	$('#createLast').val('');
																	$('#createEmail').val('');
																	$('#createEmailCheck').val('');
																	$('#createPassword').val('');
																	$('#createPasswordCheck').val('');
																}
																else if($('#createPassword').val() == '')
																{
																	alert('Please enter a password.');
																	$('#createFirst').val('');
																	$('#createLast').val('');
																	$('#createEmail').val('');
																	$('#createEmailCheck').val('');
																	$('#createPassword').val('');
																	$('#createPasswordCheck').val('');
																}
																else if($('#createPasswordCheck').val() == '')
																{
																	alert('Please enter a password.');
																	$('#createFirst').val('');
																	$('#createLast').val('');
																	$('#createEmail').val('');
																	$('#createEmailCheck').val('');
																	$('#createPassword').val('');
																	$('#createPasswordCheck').val('');
																}
																else if($('#createPassword').val() != $('#createPasswordCheck').val())
																{
																	alert('Passwords Do Not Match.');
																	$('#createFirst').val('');
																	$('#createLast').val('');
																	$('#createEmail').val('');
																	$('#createEmailCheck').val('');
																	$('#createPassword').val('');
																	$('#createPasswordCheck').val('');
																}
																else
																{
																	_fname = $('#createFirst').val();
																	_lname = $('#createLast').val();
																	_email = $('#createEmail').val();
																	_emailCheck = $('#createEmailCheck').val();
																	_pass = $('#createPassword').val();
																	_passCheck = $('#createPasswordCheck').val();
																	
																	
																	$.ajax({ 
																		url:"/Atlas/UserLoginService",
																		data:{
																			"firstName": _fname,
																			"lastName": _lname,
																			"emailAddress": _email,
																			"password": _pass,
																			"method":"signUp"
																		},
																		type:'POST',
																		dataType:"json",
																		success: function(html){
																			$('#globalSettings').data('userData',html);
																			setSession("True");
																			loadProfile(html['userData']);
																			
																		},
																		error: function(html){
																			alert("Email address already in use. Please try again.");
																		}
																	}); //Closes ajax
																	
																	$('#createFirst').val('');
																	$('#createLast').val('');
																	$('#createEmail').val('');
																	$('#createEmailCheck').val('');
																	$('#createPassword').val('');
																	$('#createPasswordCheck').val('');
																}
																
																return false;
															})
													)//END SIGN UP FUNCTION
												)
											)
										)//END SIGN UP		
								);
				
				//readSession();
				
			}
					
			function setSession(status){
				$.session.set("authorized", status);
			}
			
			function readSession(){
				alert($.session.get("authorized"));
			}
					
			function loadProfile(userData)
			{
				if(userData.length === 0)
				{
					alert('Invalid username and/or password combination. Please try again.');
				}
				else
				{
					setSession("True");
					$('#mainBody').ProfileView({'FullName':userData[0]['Full Name'],'FirstName':userData[0]['First Name'],'LastName':userData[0]['Last Name'],'PersonId':userData[0]['Person ID'],'emailAddress':userData[0]['Email Address'],'accountType':userData[0]['User Type']});
				}
				
			} 
			
			function userLoginAction()
			{
				if($.session.get("authorized") === "True")
				{
					var _uname = '';
					var _pword = '';
														
					_uname = $.session.get("userEmail");
					_pword = $.session.get("userPass");
					
					//$('#unameField').val('');
					//$('#pwordField').val('');
					
					$.ajax({ 
						url:"/Atlas/UserLoginService",
						data:{
							"emailAddress": _uname,
							"password": _pword,
							"method":"signIn"
						},
						type:'POST',
						dataType:"json",
						success: function(html){
							$('#globalSettings').data('userData',html);
							$.session.set("userEmail", _uname);
							$.session.set("userPass", _pword);
							$.session.set("userId",html['userData'][0]['Person ID']);
							$.session.set("accessLevel",html['userData'][0]['User Type']);
							loadProfile(html['userData']);
						},
						error: function(html){
							alert("Invalid username/password combination." +
									"\nPlease refresh your browser and try again.");
						}
					}); //Closes ajax
				
					return false;
				}
				else
				{
					var _uname = '';
					var _pword = '';
														
					if($('#unameField').val() == '')
					{
						alert('Please Enter Your Username.');
						$('#unameField').val('');
						$('#pwordField').val('');
					}
					else if($('#pwordField').val() == '')
					{
						alert('Please Enter Your Password.');
						$('#unameField').val('');
						$('#pwordField').val('');
					}
					else
					{
						_uname = $('#unameField').val();
						_pword = $('#pwordField').val();
						
						$('#unameField').val('');
						$('#pwordField').val('');
						
						$.ajax({ 
							url:"/Atlas/UserLoginService",
							data:{
								"emailAddress": _uname,
								"password": _pword,
								"method":"signIn"
							},
							type:'POST',
							dataType:"json",
							success: function(html){
								$('#globalSettings').data('userData',html);
								$.session.set("userEmail", _uname);
								$.session.set("userPass", _pword);
								$.session.set("userId",html['userData'][0]['Person ID']);
								loadProfile(html['userData']);
							},
							error: function(html){
								alert("Invalid username/password combination." +
										"\nPlease refresh your browser and try again.");
							}
						}); //Closes ajax
					
						return false;
					}
				}
				
			}
			
	
	
	</script>

</head>
<body>
	<!-- Holds Data on page -->
	<div id="globalSettings" style="display: none;"></div>
	<!-- <div id="header"></div>
	<div id="links"></div>
	<div id="nav"></div> -->
	<div id="mainBody">
		<div id="processing"></div>
		<div id="welcome"></div>
		<div id="appLoader" style="width:100%;height:910px;display: none;">
		
		</div>
	</div>
	<div id="footer">
		<div>
			<label>Copyright William Pegg 2013 | All Rights Reserved | Email: pegg.server@gmail.com</label>
		</div>
	</div>
</body>
</html>