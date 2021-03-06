<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<html>
<head>
	<meta name="viewport" content="width=1024" />
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
	
	<title>Secret Santa</title>
	
	<link rel="stylesheet" type="text/css" href="styles/index.css" >
	<link rel="stylesheet" type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/themes/ui-lightness/jquery-ui.min.css" media="screen" > 
	<link rel="stylesheet" type="text/css" href="styles/jqueryUi.css" media="screen" >
	<link rel="stylesheet" media="screen" href="styles/jquery.handsontable.full.css">
	
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.js"></script>
	

	<script  src="plugins/jquery.handsontable.full.js"></script>
	<script  src="plugins/jquery.dataTables.min.js"></script>
	<script  src="plugins/jquery.session.js"></script>
	<script  src="plugins/css_browser_selector.js" type="text/javascript"></script>
	
	<style type="text/css">
	.ie #RecipientBody{
		width: 800px;
		margin-left:30px;
	}
	.chrome #RecipientBody{
		margin-left: 20px;
		margin-bottom:25px;
	}
	.chrome #leftSideMenu{
		width: 100px;
		float: left;
	}
	.ie #leftSideMenu{
		width: 120px;
		float: left;
	}
	.ie #rightSideBody{
	width: 580px;
	float: right;
	margin-left: 10px;
	}
	.chrome #rightSideBody{
	width: 682px;
	float: right;
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
		
		buildSecrectSantaView();
		
		var gifts;
		var Mygifts;
		var allRecipients;
		
				
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
			});//Closes $(document).ready(
					
		
			buildSecrectSantaView = function(){
				
				getRecipient($.session.get("userId"));
				$('#processing').show();
				
				setTimeout(function(){
					
					$('#processing').hide();
					
					var _me = $.session.get("userId");
					displayMyGifts(_me);
					
				},2000);
				
				
			};
			
			getRecipient = function(userId){
				$.ajax({ 
					url:"/SecretSanta/SecretSantaDataService",
					data:{
						"personId": userId,
						"method":"getRecipient"
					},
					type:'POST',
					dataType:"json",
					success: function(html){
						$('#globalSettings').data('recipientData',html);
						
						displayRecipient(html['recipientData'][0]['Person ID'],html['recipientData'][0]['First Name'],html['recipientData'][0]['Last Name'],html['recipientData'][0]['Gift List ID']);
						
					},
					error: function(html){
						alert("Error Gathering Data. Please try again.");
					}
				}); //Closes ajax
			};
			
			displayRecipient = function(personId,fName,lName,giftListId){
				
				$('body').attr({'style':'height: 100%; width: 100%; overflow: hidden;background:url("images/main_background.jpg");'});
				
				$('#RecipientBody')
					.append(
						$('<div/>')
							.attr({'id':'leftSideMenu'})
							.append(
								$('<ul/>')
									.attr({'id':'ssRecipNav'})
									.append(
										$('<li/>')
											.attr({'style':'list-style: none;padding: 4px 10px;color: #fff;background:#A20D13;width:90px;border: #000;border-width: thin;border-style:solid;font-size:19px;'})
											.append(
												$('<label/>')
													.attr({'id':'mygifts','style':'cursor:pointer;'})
													.text('My Gift List')
													.click(function(){
														var _me = $.session.get("userId");
														
														displayMyGifts(_me);
													})
											)
									)
									.append(
										$('<li/>')
											.attr({'style':'list-style: none;padding: 4px 10px;color: #fff;background:#A20D13;width:90px;border: #000;border-width: thin;border-style:solid;font-size:19px;'})
											.append(
												$('<label/>')
													.attr({'id':'recipName','style':'cursor:pointer;'})
													.text('My Secret Santa Recipient')
													.click(function(){
														displayMyRecip(personId,fName,lName);
													})
											)
									)
									.append(
										$('<li/>')
											.attr({'style':'list-style: none;padding: 4px 10px;color: #fff;background:#A20D13;width:90px;border: #000;border-width: thin;border-style:solid;font-size:19px;'})
											.append(
												$('<label/>')
													.attr({'id':'recipGiftList','style':'cursor:pointer;'})
													.text('My Recipient\'s List')
													.click(function(){
														displayMyRecipGiftList(personId,giftListId);
													})
											)
									)		
							)
					)
					.append(
						$('<div/>')
							.attr({'id':'rightSideBody'})
					);
				
				if($.session.get("accessLevel") === 'Admin')
				{
					$('#ssRecipNav')
						.append(
							$('<li/>')
								.attr({'style':'list-style: none;padding: 4px 10px;color: #fff;background:#A20D13;width:90px;border: #000;border-width: thin;border-style:solid;font-size:19px;'})
								.append(
									$('<label/>')
										.attr({'id':'recipGiftList','style':'cursor:pointer;'})
										.text('View Assignments')
										.click(function(){
											displayAllAssignments();
										})
								)		
						);
				}
				else if($.session.get("accessLevel") === 'PowerUser')
				{
					$('#ssRecipNav')
						.append(
							$('<li/>')
								.attr({'style':'list-style: none;padding: 4px 10px;color: #fff;background:#A20D13;width:90px;border: #000;border-width: thin;border-style:solid;font-size:19px;'})
								.append(
									$('<label/>')
										.attr({'id':'recipGiftList','style':'cursor:pointer;'})
										.text('View Assignments')
										.click(function(){
											displayAllAssignments();
										})
								)		
						);
				}
			};
			
			displayMyRecip = function(personId,fName,lName){
				$('#nameDiv').remove();
				$('#listDiv').remove();
				$('#MyListDiv').remove();
				$('#addGiftsButton').remove();
				$('#fullRecipList').remove();
				
				$('#rightSideBody')
					.append(
						$('<div/>')
							.attr({'id':'nameDiv','style':'text-align:center;'})
							.append($('<br/>'))
							.append($('<br/>'))
							.append(
								$('<label/>')
									.attr({'id':'recipName','style':'font-weight:normal;color:#000000;letter-spacing:1pt;word-spacing:2pt;font-size:33px;text-align:left;font-family:comic sans, comic sans ms, cursive, verdana, arial, sans-serif;line-height:1;'})
									.text('My Secret Santa Recipient is: ')		
							)
							.append($('<br/>'))
							.append(
								$('<label/>')
									.attr({'id':'recipFullName','style':'font-weight:normal;color:#20E82E;letter-spacing:1pt;word-spacing:2pt;font-size:30px;text-align:left;font-family:comic sans, comic sans ms, cursive, verdana, arial, sans-serif;line-height:1;'})
									.text(fName + ' ' + lName)
							)
					);
			};
			
			displayMyGifts = function(myID){
				$('#nameDiv').remove();
				$('#listDiv').remove();
				$('#MyListDiv').remove();
				$('#addGiftsButton').remove();
				$('#fullRecipList').remove();
				
				$('#processing').show();
				gatherMyListItems(myID);
				
				setTimeout(function(){
				
					$('#processing').hide();
					
					var MyGiftList = Mygifts;
					
					$('#rightSideBody')
						
						.append(
							$('<div/>')
								.attr({'id':'MyListDiv'})
								.append(
									$('<table/>')
										.attr({'id':'recipientGiftList'})
										.append(
											$('<tr/>')
												/* .append(
													$('<td/>')
														.attr({'visible':'false'})
												) */
												.append(
													$('<td/>')
														.attr('style','text-align: center;font-size: 14px;font-family: Georgia;font-weight: bold;color: #ffffff;background: #A20D13;width:120px')
														.append(
															$('<label/>')
																.text('Gift Name')
														)
												)
												.append(
													$('<td/>')
														.attr('style','text-align: center;font-size: 14px;font-family: Georgia;font-weight: bold;color: #ffffff;background: #A20D13;width:300px')
														.append(
															$('<label/>')
																.text('Description')
														)
												)
												.append(
													$('<td/>')
														.attr('style','text-align: center;font-size: 14px;font-family: Georgia;font-weight: bold;color: #ffffff;background: #A20D13;width:200px')
														.append(
															$('<label/>')
																.text('Website')
														)		
												)
												.append(
													$('<td/>')
														.attr('style','text-align: center;font-size: 14px;font-family: Georgia;font-weight: bold;color: #ffffff;background: #A20D13;width:200px')
												)
										)
								)
						);
					
					for(var i=0;i<MyGiftList.length;i++)
					{
						curData = MyGiftList[i];
						
						var _oddRow = 'background-color:#F8BEDC;;';
						var _evenRow='background-color:#ffffff;';
						
						if (i%2 === 0)
						{
							$('#recipientGiftList')
							.append(
								$('<tr/>')
									.attr('style',_evenRow)
									.append(
										$('<td/>')
											.append(
												$('<label/>')
													.text(curData['Gift Name'])
											)
									)
									.append(
										$('<td/>')
											.append(
												$('<label/>')
													.text(curData['Gift Description'])
											)
									)
									.append(
										$('<td/>')
											.append(
												$('<label/>')
													.text(curData['URL'])
											)
									)
									.append(
										$('<td/>')
											.append(
												$('<button/>')
													.text('Delete')
													.addClass('RemoveButton')
													.attr({'id':curData['Gift ID'],'style':'-moz-box-shadow:inset 0px 1px 0px 0px #f29c93;-webkit-box-shadow:inset 0px 1px 0px 0px #f29c93;box-shadow:inset 0px 1px 0px 0px #f29c93;background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #fe1a00), color-stop(1, #ce0100) );background:-moz-linear-gradient( center top, #fe1a00 5%, #ce0100 100% );filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=\'#fe1a00\', endColorstr=\'#ce0100\');background-color:#fe1a00;-webkit-border-top-left-radius:30px;-moz-border-radius-topleft:30px;border-top-left-radius:30px;-webkit-border-top-right-radius:30px;-moz-border-radius-topright:30px;border-top-right-radius:30px;-webkit-border-bottom-right-radius:30px;-moz-border-radius-bottomright:30px;border-bottom-right-radius:30px;-webkit-border-bottom-left-radius:30px;-moz-border-radius-bottomleft:30px;border-bottom-left-radius:30px;text-indent:0px;display:inline-block;color:#ffffff;font-family:Arial;font-size:17px;font-weight:bold;font-style:normal;height:24px;line-height:24px;width:90px;text-decoration:none;text-align:center;text-shadow:1px 1px 0px #b23e35;cursor:pointer;'})
													.click(function(){
														removeMyGift($(this));
													})
											)
									)
							);
						}
						else
						{
							$('#recipientGiftList')
							.append(
								$('<tr/>')
									.attr('style',_oddRow)
									.append(
										$('<td/>')
											.append(
												$('<label/>')
													.text(curData['Gift Name'])
											)
									)
									.append(
										$('<td/>')
											.append(
												$('<label/>')
													.text(curData['Gift Description'])
											)
									)
									.append(
										$('<td/>')
											.append(
												$('<label/>')
													.text(curData['URL'])
											)
									)
									.append(
										$('<td/>')
											.append(
												$('<button/>')
													.text('Delete')
													.addClass('RemoveButton')
													.attr({'id':curData['Gift ID'],'style':'-moz-box-shadow:inset 0px 1px 0px 0px #f29c93;-webkit-box-shadow:inset 0px 1px 0px 0px #f29c93;box-shadow:inset 0px 1px 0px 0px #f29c93;background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #fe1a00), color-stop(1, #ce0100) );background:-moz-linear-gradient( center top, #fe1a00 5%, #ce0100 100% );filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=\'#fe1a00\', endColorstr=\'#ce0100\');background-color:#fe1a00;-webkit-border-top-left-radius:30px;-moz-border-radius-topleft:30px;border-top-left-radius:30px;-webkit-border-top-right-radius:30px;-moz-border-radius-topright:30px;border-top-right-radius:30px;-webkit-border-bottom-right-radius:30px;-moz-border-radius-bottomright:30px;border-bottom-right-radius:30px;-webkit-border-bottom-left-radius:30px;-moz-border-radius-bottomleft:30px;border-bottom-left-radius:30px;text-indent:0px;display:inline-block;color:#ffffff;font-family:Arial;font-size:17px;font-weight:bold;font-style:normal;height:24px;line-height:24px;width:90px;text-decoration:none;text-align:center;text-shadow:1px 1px 0px #b23e35;cursor:pointer;'})
													.click(function(){
														removeMyGift($(this));
													})
											)
									)
							);
						}
					}
					
					
					$('#rightSideBody')
						.append(
							$('<button/>')
								.attr({'id':'addGiftsButton','style':'-moz-box-shadow:inset 0px 1px 0px 0px #c1ed9c;-webkit-box-shadow:inset 0px 1px 0px 0px #c1ed9c;box-shadow:inset 0px 1px 0px 0px #c1ed9c;background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #536D18), color-stop(1, #6D9C04) );background:-moz-linear-gradient( center top, #9dce2c 5%, #8cb82b 100% );filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=\'#9dce2c\', endColorstr=\'#8cb82b\');background-color:#9dce2c;-webkit-border-top-left-radius:30px;-moz-border-radius-topleft:30px;border-top-left-radius:30px;-webkit-border-top-right-radius:30px;-moz-border-radius-topright:30px;border-top-right-radius:30px;-webkit-border-bottom-right-radius:30px;-moz-border-radius-bottomright:30px;border-bottom-right-radius:30px;-webkit-border-bottom-left-radius:30px;-moz-border-radius-bottomleft:30px;border-bottom-left-radius:30px;text-indent:0px;display:inline-block;color:#ffffff;font-family:Comic Sans MS;font-size:17px;font-weight:normal;font-style:normal;height:24px;line-height:24px;width:90px;text-decoration:none;text-align:center;text-shadow:1px 1px 0px #689324;cursor:pointer;'})
								.text('Add Gifts')
								.click(function(){
									addMyGift();
								})
						);
					
				},3000);
				
			};
			
			displayMyRecipGiftList = function(personId){
				$('#nameDiv').remove();
				$('#listDiv').remove();
				$('#MyListDiv').remove();
				$('#addGiftsButton').remove();
				$('#fullRecipList').remove();
				
				var _giftTable;
				
				$('#processing').show();
				gatherListItems(personId);
				
				setTimeout(function(){
				
					$('#processing').hide();
					
					var giftList = gifts;
					
					$('#rightSideBody')
						.append(
							$('<div/>')
								.attr({'id':'listDiv'})
								.append(
									$('<table/>')
										.attr({'id':'recipientGiftList'})
										.append(
											$('<tr/>')
												.append(
													$('<td/>')
														.attr('style','text-align: center;font-size: 14px;font-family: Georgia;font-weight: bold;color: #ffffff;background: #A20D13;width:120px;')
														.append(
															$('<label/>')
																.text('Gift Name')
														)
												)
												.append(
													$('<td/>')
														.attr('style','text-align: center;font-size: 14px;font-family: Georgia;font-weight: bold;color: #ffffff;background: #A20D13;width:300px;')
														.append(
															$('<label/>')
																.text('Description')
														)
												)
												.append(
													$('<td/>')
														.attr('style','text-align: center;font-size: 14px;font-family: Georgia;font-weight: bold;color: #ffffff;background: #A20D13;width:200px;')
														.append(
															$('<label/>')
																.text('Website')
														)		
												)
										)
								)
						);
					
					for(var i=0;i<giftList.length;i++)
					{
						curData = giftList[i];
						
						var _oddRow = 'background-color:#F8BEDC;';
						var _evenRow='background-color:#ffffff;';
						
						if(i%2 === 0)
						{
							$('#recipientGiftList')
							.append(
								$('<tr/>')
									.attr('style',_evenRow)
									.append(
										$('<td/>')
											.append(
												$('<label/>')
													.text(curData['Gift Name'])
											)
									)
									.append(
										$('<td/>')
											.append(
												$('<label/>')
													.text(curData['Gift Description'])
											)
									)
									.append(
										$('<td/>')
											.append(
												$('<label/>')
													.text(curData['URL'])
											)
									)
							);
						}
						else
						{
							$('#recipientGiftList')
							.append(
								$('<tr/>')
									.attr('style',_oddRow)
									.append(
										$('<td/>')
											.append(
												$('<label/>')
													.text(curData['Gift Name'])
											)
									)
									.append(
										$('<td/>')
											.append(
												$('<label/>')
													.text(curData['Gift Description'])
											)
									)
									.append(
										$('<td/>')
											.append(
												$('<label/>')
													.text(curData['URL'])
											)
									)
							);
						}
					}
					
				},3000);
				
			};
			
			removeMyGift = function(gift){
				$.ajax({ 
					url:"/SecretSanta/SecretSantaDataService",
					data:{
						"giftId": gift.attr('id'),
						"personId": $.session.get('userId'),
						"method":"removeGift"
					},
					type:'POST',
					dataType:"json",
					success: function(html){
						$('#globalSettings').data('giftListData',html);
						displayMyGifts($.session.get("userId"));
					},
					error: function(html){
						alert("Error Gathering Gift List Data. Please try again.");
					}
				}); //Closes ajax
			};
			
			addMyGift = function(){
				$('#SantaBody')
					.append(
						$('<div/>')
							.attr({'id':'dialogDiv'})
							.append(
								$('<div/>')
									.attr({'id':'addGiftForm','visible':'false'})
									.append(
										$('<table/>')
											.append(
												$('<tr/>')
													.append(
														$('<td/>')
															.append(
																$('<label/>')
																	.text('Gift Name: ')
															)
													)
													.append(
														$('<td/>')
															.append(
																$('<input/>')
																	.attr({'type':'text','id':'giftName'})
															)
													)
											)
											.append(
												$('<tr/>')
													.append(
														$('<td/>')
															.append(
																$('<label/>')
																	.text('Gift Description: ')
															)
													)
													.append(
														$('<td/>')
															.append(
																$('<textarea/>')
																	.attr({'id':'giftDesc','col':'45','row':'30'})
															)
													)
											)
											.append(
												$('<tr/>')
													.append(
														$('<td/>')
															.append(
																$('<label/>')
																	.text('Gift WebSite: ')
															)
													)
													.append(
														$('<td/>')
															.append(
																$('<input/>')
																	.attr({'type':'text','id':'giftUrl'})
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
																	.attr({'id':'addGiftButton'})
																	.text('Submit')
																	.click(function(){
																		if($('#giftName').val() === '')
																		{
																			alert('Please Enter Gift Name.');
																		}
																		else if($('#giftDesc').val() === '')
																		{
																			alert('Please Enter Gift Description.');
																		}
																		else
																		{
																			addTheGift();	
																		}
																	})
															)
													)
											)
									)
							)
					);
				
				$('#addGiftForm').dialog({
					'height': '320',
					'width': '600',
					'modal':'true',
					'closeOnEscape': 'true',
		            'resizable': 'false',
		            'close': function(ev, ui) { 
		            	$(this).remove();
		            }
				})
				.show();
				
			};
			
			
			 addTheGift = function(){
				 var urlCheck = $('#giftUrl').val();
				 if(urlCheck === '')
				{
					 urlCheck = 'N/A';
				}
				 
				 $.ajax({ 
						url:"/SecretSanta/SecretSantaDataService",
						data:{
							"giftName": $('#giftName').val(),
							"giftDescr": $('#giftDesc').val(),
							"giftUrl": urlCheck,
							"personId": $.session.get('userId'),
							"method":"addGift"
						},
						type:'POST',
						dataType:"json",
						success: function(html){
							$('#globalSettings').data('giftListData',html);
							displayMyGifts($.session.get("userId"));
							$('#addGiftForm').remove();
						},
						error: function(html){
							alert("Error Gathering Gift List Data. Please try again.");
						}
					}); //Closes ajax 
			 };
			
			gatherListItems = function(personId){
				$.ajax({ 
					url:"/SecretSanta/SecretSantaDataService",
					data:{
						"personId": personId,
						"method":"getList"
					},
					type:'POST',
					dataType:"json",
					success: function(html){
						$('#globalSettings').data('giftListData',html);
						gifts = html['giftListData'];
						
					},
					error: function(html){
						alert("Error Gathering Gift List Data. Please try again.");
					}
				}); //Closes ajax
			};
			
			gatherMyListItems = function(personId){
				$.ajax({ 
					url:"/SecretSanta/SecretSantaDataService",
					data:{
						"personId": personId,
						"method":"getMyList"
					},
					type:'POST',
					dataType:"json",
					success: function(html){
						$('#globalSettings').data('MygiftListData',html);
						Mygifts = html['MygiftListData'];
						
					},
					error: function(html){
						alert("Error Gathering Gift List Data. Please try again.");
					}
				}); //Closes ajax
			};
			
			displayAllAssignments = function(){
				
				getAllRecipients();
				$('#processing').show();
				
				setTimeout(function(){
					
					$('#processing').hide();
					
					displayFullRecipList();
					
				},2000);
			};
			
			getAllRecipients = function(){
				$.ajax({ 
					url:"/SecretSanta/SecretSantaDataService",
					data:{
						"method":"getAllRecipients"
					},
					type:'POST',
					dataType:"json",
					success: function(html){
						$('#globalSettings').data('FullRecipList',html);
						allRecipients = html['FullRecipList'];
						
					},
					error: function(html){
						alert("Error Gathering Gift List Data. Please try again.");
					}
				}); //Closes ajax
			};
			
			displayFullRecipList = function(){
				$('#nameDiv').remove();
				$('#listDiv').remove();
				$('#MyListDiv').remove();
				$('#addGiftsButton').remove();
				$('#fullRecipList').remove();
				
				var _fullList = allRecipients;
				
				$('#rightSideBody')
					.append(
						$('<div/>')
							.attr({'id':'fullRecipList'})
							.append(
								$('<table/>')
									.attr({'id':'fullRecipTable'})
									.append(
										$('<tr/>')
											.append(
												$('<td/>')
													.attr('style','text-align: center;font-size: 14px;font-family: Georgia;font-weight: bold;color: #ffffff;background: #A20D13;width:300px;')
													.append(
														$('<label/>')
															.text('Person Name')
													)
											)
											.append(
												$('<td/>')
													.attr('style','text-align: center;font-size: 14px;font-family: Georgia;font-weight: bold;color: #ffffff;background: #A20D13;width:200px;')
													.append(
														$('<label/>')
															.text('Assigned Recipient')
													)		
											)
									)	
							)
					);
				
				for(var i=0;i<_fullList.length;i++)
				{
					var curData = _fullList[i]
					var _oddRow = 'background-color:#F8BEDC;';
					var _evenRow='background-color:#ffffff;';
					var _curRecip = curData['Recipient Name']
					
					if(_curRecip === '' || _curRecip === null)
					{
						_curRecip = ' ';
					}
					
					if(i%2 === 0)
					{
						
						
						$('#fullRecipTable')
							.append(
								$('<tr/>')
									.attr('style',_evenRow)
									.append(
										$('<td/>')
											.append(
												$('<label/>')
													.text(curData['Person Name'])
											)
									)
									.append(
										$('<td/>')
											.append(
												$('<label/>')
													.text(_curRecip)
											)
									)
							);
					}
					else
					{
						$('#fullRecipTable')
						.append(
							$('<tr/>')
								.attr('style',_oddRow)
								.append(
									$('<td/>')
										.append(
											$('<label/>')
												.text(curData['Person Name'])
										)
								)
								.append(
									$('<td/>')
										.append(
											$('<label/>')
												.text(_curRecip)
										)
								)
						);
					}
				}
				
			};
	
	</script>
</head>

<body>
	<div id="globalSettings" style="display:none;"></div>
	<div id="SantaBody" style="background-color: rgba(238, 226, 226, 0);">
		<div id="SantaHeader">
			<!--<img id="appName" src="images/header.jpg"></img> -->
		</div>
		<div id="processing"></div>
		<div id="RecipientBody">
		</div>
	</div>
</body>
</html>