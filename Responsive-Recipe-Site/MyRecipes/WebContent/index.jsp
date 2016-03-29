<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>My Recipes</title>
	<!-- <link rel="stylesheet" href="styles/jquery-ui.css">
	<script src="javascript/jquery-ui.js"></script> 
	
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
	<link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Roboto:300,400,500,700">
	<link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/icon?family=Material+Icons">
	<link rel="stylesheet" type="text/css" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="dist/css/bootstrap-material-design.css">
	<link rel="stylesheet" type="text/css" href="dist/css/ripples.min.css">
	 
	<script  src="plugins/jquery.handsontable.full.js"></script>
	<script  src="plugins/jquery.dataTables.min.js"></script>
	<script  src="plugins/jquery.session.js"></script>
	<script  src="plugins/css_browser_selector.js" type="text/javascript"></script> -->
	
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	
	<!-- Mobile support -->
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- Material Design fonts -->
	<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Roboto:300,400,500,700" type="text/css">
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
	<!-- Bootstrap -->
	<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet">
	<!-- Bootstrap Material Design -->
	<link href="dist/css/bootstrap-material-design.css" rel="stylesheet">
	<link href="dist/css/ripples.min.css" rel="stylesheet">
	<!-- Dropdown.js -->
	<link href="//cdn.rawgit.com/FezVrasta/dropdown.js/master/jquery.dropdown.css" rel="stylesheet">
	<!-- Page style -->
	<link href="styles/index.css" rel="stylesheet">
	<!-- jQuery -->
	<script src="//code.jquery.com/jquery-1.10.2.min.js"></script>
	
	<script src="javascript/jquery.justified.min.js"></script>
	<link href="styles/jquery.justified.css" rel="stylesheet">
	
	<script type="text/javascript">
		$(document).ready(function(){
			var homeRecipeData;
			var popupRecipeData;
			var searchRecipeData;
			loadHomePage();
			
			var ingredient = document.createElement('ingredient');
			var tag = document.createElement('tag');
			
			$('#searchText').on("keydown", function(event){
				event.stopPropagation();
				if(event.which === 13){
					$('#searchButton').click();
					return false;
				}
			});
			
			if(!Array.prototype.filter) {
			    Array.prototype.filter = function (fun) {
			        "use strict";
			        if ((this === void(0)) || (this === null))
			        {throw new TypeError();}
	
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
		});
		
		navBrowse = function(){
			$('#add').removeClass('active');
			$('#home').removeClass('active');
			$('#browse').addClass('active');
			$('#photos').remove();
			$('#searchText').val('');
			$('#addRecipeForm').remove();
			$('#recipePopup').remove();
			$('#searchTitle').remove();
			$('#hamburger').trigger("click");
		}
		navAdd = function(){
			var addRecipeTemplate = $('#add-recipe-template').html();
			$('#addRecipeForm').remove();
			$('#browse').removeClass('active');
			$('#home').removeClass('active');
			$('#add').addClass('active');
			$('#photos').remove();
			$('#searchText').val('');
			$('#recipePopup').remove();
			$('#searchTitle').remove();
			$('#hamburger').trigger("click");
			$('#RecipeBody').append($('<section/>').attr('id','addRecipeForm').append(addRecipeTemplate));
		}
		navHome = function(){
			$('#browse').removeClass('active');
			$('#add').removeClass('active');
			$('#home').addClass('active');
			$('#addRecipeForm').remove();
			$('#recipePopup').remove();
			$('#photos').remove();
			$('#searchText').val('');
			$('#searchTitle').remove();
			$('#hamburger').trigger("click");
			loadHomePage();
		}
		function getRandomSize(min, max) {
			return Math.round(Math.random() * (max - min) + min);
		}
		loadHomePage = function(){
			$('#RecipeBody').append($('<section/>').attr('id','photos'));
			$.ajax({ 
				url:"/MyRecipes/RecipeDataService",
				data:{"method":"loadHomePage"},
				type:'POST',
				async: false,
				dataType:"json",
				success: function(html){
					$('#globalSettings').data('recipeData',html);
					homeRecipeData = html['recipeData'];
				},
				error: function(html){
					alert("Error Gathering Data. Please try again.");
				}
			}); //Closes ajax
			var imagesJson = {};
			var titlesJson = {};
			for(var i = 0; i < homeRecipeData.length; i++){
				var tmp = jQuery.parseJSON(homeRecipeData[i])
				imagesJson[tmp.RecipeID] = tmp.ImageUrl;
				titlesJson[tmp.RecipeID] = tmp.Title;
			}
			
			$.each(imagesJson,function(index,element){
				var curImageUrl =  element;
				var curRecipeId = index;
				var curTitle = titlesJson[index];
				$('#photos').append('<img src="'+curImageUrl+'" alt="food" title="'+curTitle+'" id="'+index+'" onclick="getSingleRecipe(this.id)">');
			});
		};
		
		findRecipies = function(){
			$('#addRecipeForm').remove();
			$('#recipePopup').remove();
			$('#photos').remove();
			$('#searchTitle').remove();
			var _searchText = $('#searchText').val();
			$.ajax({ 
				url:"/MyRecipes/RecipeDataService",
				data:{
					"searchText":_searchText,
					"method":"searchRecipes"
				},
				type:'POST',
				async: false,
				dataType:"json",
				success: function(html){
					$('#globalSettings').data('recipeData',html);
					$('#RecipeBody').append($('<section/>').attr('id','photos'));
					searchRecipeData = html['recipeData'];
					$('#photos').before($('<section/>').attr('id','searchTitle').append($('<h2/>').text('Search Results for: '+_searchText)));
				},
				error: function(html){
					alert("Error Gathering Data. Please try again.");
				}
			}); //Closes ajax
			var imagesJson = {};
			var titlesJson = {};
			for(var i = 0; i < searchRecipeData.length; i++){
				var tmp = jQuery.parseJSON(searchRecipeData[i])
				imagesJson[tmp.RecipeID] = tmp.ImageUrl;
				titlesJson[tmp.RecipeID] = tmp.Title;
			}
			
			$.each(imagesJson,function(index,element){
				var curImageUrl =  element;
				var curRecipeId = index;
				var curTitle = titlesJson[index];
				$('#photos').append('<img src="'+curImageUrl+'" alt="food" title="'+curTitle+'" id="'+index+'" onclick="getSingleRecipe(this.id)">');
			});
		};
		
		getSingleRecipe = function(recipeId){
			$.ajax({ 
				url:"/MyRecipes/RecipeDataService",
				data:{
					"recipeId": recipeId,
					"method":"getSingleRecipe"
				},
				type:'POST',
				async: false,
				dataType:"json",
				success: function(html){
					$('#globalSettings').data('recipeDataModal',html);
					popupRecipeData = html['recipeDataModal'];
					var recipe = jQuery.parseJSON(popupRecipeData)
					var recipePopup = $('#recipe-modal-dialog-template').html();
					$('#recipeModal').append(recipePopup);
					$('#recipeModalDialogTitle').text(recipe.Title);
					$('.modal-body')
						.append($('<h3/>').text('Description'))
						.append($('<section/>').attr('id','modalRecipeDescription'))
						.append($('<h3/>').text('Ingredients'))
						.append($('<section/>').append($('<ul/>').attr('id','modalRecipeIngredients')))
						.append($('<h3/>').text('Directions'))
						.append($('<section/>').attr('id','modalRecipeDirections'))
					$('#recipePopup').removeClass('modal');
					$('#recipePopup').css({
						'position':'absolute',
						'top':'10%',
						'right':'auto',
						'left':'35%',
						'bottom':'auto',
						'z-index':'1',
						'display':'block'
					});
					$.each(recipe.Ingredients,function(index,element){
						var curIngredient = element.Ingredient;
						var curQuant = element.Quantity;
						var curMeas = element.Measurement;
						$('#modalRecipeIngredients').append(
							$('<li/>').text(curIngredient+' - '+curQuant+' '+curMeas)
						)
					});
					var _directions = recipe.Steps[0].Directive.split(/\n/)
					$.each(_directions,function(index,element){
						var curStep = element;
						$('#modalRecipeDirections').append(
							$('<p/>').text(curStep)
						)
					});
					var _desc = recipe.Description.split(/\n/)
					$.each(_desc,function(index,element){
						var curLine = element;
						$('#modalRecipeDescription').append(
							$('<p/>').text(curLine)
						)
					});
				},
				error: function(html){
					alert("Error Gathering Data. Please try again.");
				}
			}); //Closes ajax
		};
		addIngredientBox = function(){
			var addIngredientToList = $('#add-recipe-ingredient-template').html();
			$('#ingredientsList').append(addIngredientToList);
		};
		removeLastIngredientBox = function(){
			var elems = document.getElementsByTagName("ingredient");
			var ingredArr = jQuery.makeArray( elems )
			if (ingredArr.length > 2){
				$( "ingredient" ).last().parent().remove();	
			}
		};
		addTagBox = function(){
			var addTagToList = $('#add-recipe-tag-template').html();
			$('#tagsList').append(addTagToList);
		};
		removeLastTagBox = function(){
			var elems = document.getElementsByTagName("tag");
			var tagArr = jQuery.makeArray( elems )
			if (tagArr.length > 1){
				$( "tag" ).last().remove();	
			}
		};
		closeModalPopup = function(){
			$('#recipePopup').remove();
		};
		addRecipe = function(){
			//alert('added!');
			var _inputTitle = $('#inputTitle').val();
			var _inputDescription = $('#descTextArea').val();
			var _inputSteps = $('#Steps').val();
			var _inputImage = $('#inputImagUrl').val();
			var _inputIngredients = {};
			var _inputTags = {};
			
			var elems = document.getElementsByTagName("ingredient");
			var ingredArr = jQuery.makeArray( elems );
			var ingredCounter = 1;
			for(var i=0;i<ingredArr.length;i++){
				if(ingredArr[i].childNodes[1].className === 'btn btn-raised btn-info')
				{}
				else{
					var _ingredient = {};
					_ingredient['ingredient'] = ingredArr[i].childNodes[1].childNodes[1].value;
					_ingredient['quantity'] = ingredArr[i].childNodes[3].childNodes[1].value;
					_ingredient['measurement'] = ingredArr[i].childNodes[5].childNodes[1].value;
					_inputIngredients['ingredient'+ingredCounter] = _ingredient;
					ingredCounter++;
				}
			}
			var tagElems = document.getElementsByTagName("tag");
			var tagArr = jQuery.makeArray(tagElems);
			var tagCounter = 1;
			for(var i=0;i<tagArr.length;i++){
				var _tag = {};
				_tag['tag'] = tagArr[i].childNodes[1].value;
				_inputTags['tag'+tagCounter] = _tag;
				tagCounter++;
			}
			$.ajax({ 
				url:"/MyRecipes/RecipeDataService",
				data:{
					"recipeTitle": _inputTitle,
					"description": _inputDescription,
					"imageUrl": _inputImage,
					"steps": _inputSteps,
					"ingredients": JSON.stringify(_inputIngredients),
					"tags": JSON.stringify(_inputTags),
					"method":"addRecipe"
				},
				type:'POST',
				async: false,
				dataType:"json",
				success: function(html){
					alert(html.message);
				},
				error: function(html){
					alert("Error Adding Recipe. Please try again.");
				}
			}); //Closes ajax
		};
	</script>
</head>
<body>
	<div id="globalSettings" style="display:none;"></div>
	<div id="RecipeHeader">
		<div id="nav" class="navbar navbar-inverse">
			<div class="container-fluid">
				<button id="hamburger" type="button" class="c-hamburger c-hamburger--rot" data-toggle="collapse" data-target=".navbar-collapse"><span>toggle menu</span></button>
				<div class="navbar-header">
					<div class="navbar-collapse collapse navbar-responsive-collapse">
						<ul class="nav navbar-nav">
							<li id="home">
								<a href="javascript:navHome();">Home<div class="ripple-container"></div></a>
							</li>
							<li id="browse">
								<a href="javascript:navBrowse();">Browse<div class="ripple-container"></div></a>
							</li>
							<li id="add">
								<a href="javascript:navAdd();">Add<div class="ripple-container"></div></a>
							</li>
						</ul>
						<form class="navbar-form navbar-left">
							<div class="form-group is-empty">
								<input id="searchText" type="text" class="form-control col-sm-8" placeholder="Search"/>
								<span class="material-input"></span>
									<button id="searchButton" type="button" onclick="findRecipies()" class="btn btn-fab btn-fab-mini">
									  <i class="material-icons">search</i>
									</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<div id="RecipeBody">
			<section id="photos"></section>
			<div id="recipeModal" class="bs-component">
			</div>
		</div>
		<div id="processing"></div>
	</div>
	<!-- Open source code -->
	<script>
	  window.page = window.location.hash || "#about";
	
	  $(document).ready(function () {
	    if (window.page != "#about") {
	      $(".menu").find("li[data-target=" + window.page + "]").trigger("click");
	    }
	    
	  });
	  
	  (function() {
		  "use strict";
		  var toggles = document.querySelectorAll(".c-hamburger");
		  for (var i = toggles.length - 1; i >= 0; i--) {
		    var toggle = toggles[i];
		    toggleHandler(toggle);
		  };
		  function toggleHandler(toggle) {
		    toggle.addEventListener( "click", function(e) {
		      e.preventDefault();
		      (this.classList.contains("is-active") === true) ? this.classList.remove("is-active") : this.classList.add("is-active");
		    });
		  }
		})();
	
	  $(window).on("resize", function () {
	    $("html, body").height($(window).height());
	    $(".main, .menu").height($(window).height() - $(".header-panel").outerHeight());
	    $(".pages").height($(window).height());
	    if(window.innerWidth >= 768) {
			$(".c-hamburger").css({'display':'none'});
		}
	    if(window.innerWidth < 768) {
			$(".c-hamburger").css({'display':'block'});
		} 
	    
	  }).trigger("resize");
	
	  $(".menu li").click(function () {
	    // Menu
	    if (!$(this).data("target")) return;
	    if ($(this).is(".active")) return;
	    $(".menu li").not($(this)).removeClass("active");
	    $(".page").not(page).removeClass("active").hide();
	    window.page = $(this).data("target");
	    var page = $(window.page);
	    window.location.hash = window.page;
	    $(this).addClass("active");
	
	
	    page.show();
	
	    var totop = setInterval(function () {
	      $(".pages").animate({scrollTop: 0}, 0);
	    }, 1);
	
	    setTimeout(function () {
	      page.addClass("active");
	      setTimeout(function () {
	        clearInterval(totop);
	      }, 1000);
	    }, 100);
	  });
	
	  function cleanSource(html) {
	    var lines = html.split(/\n/);
	
	    lines.shift();
	    lines.splice(-1, 1);
	
	    var indentSize = lines[0].length - lines[0].trim().length,
	        re = new RegExp(" {" + indentSize + "}");
	
	    lines = lines.map(function (line) {
	      if (line.match(re)) {
	        line = line.substring(indentSize);
	      }
	
	      return line;
	    });
	
	    lines = lines.join("\n");
	
	    return lines;
	  }
	
	 
	</script>
	
	<!-- Twitter Bootstrap -->
	<script src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.6/js/bootstrap.min.js"></script>
	
	<!-- Material Design for Bootstrap -->
	<script src="dist/js/material.js"></script>
	<script src="dist/js/ripples.min.js"></script>
	<script>
	  $.material.init();
	</script>
	<!-- Dropdown.js -->
	<script src="https://cdn.rawgit.com/FezVrasta/dropdown.js/master/jquery.dropdown.js"></script>
	<script>
	  $("#dropdown-menu select").dropdown();
	</script>
	<script id="add-recipe-ingredient-template" type="text/x-custom-template">
		<div class="form-group">
			<ingredient>
				<div class="col-md-2">
					<input type="text" class="form-control" id="ingredientInput" placeholder="Ingredient">
				</div>
				<div class="col-md-2">				
					<input type="text" class="form-control" id="amountInput" placeholder="Amount">
				</div>
      			<div class="col-md-2">
        			<select id="measurementInput" class="form-control">
        				<option>Cup(s)</option>
        				<option>Ounce(s)</option>
        				<option>Pounds(s)</option>
        				<option>Tablespoon(s)</option>
        				<option>Teaspoon(s)</option>
						<option>Whole</option>
						<option>Pinch(s)</option>
        			</select>
    			</div>
			</ingredient>
		</div>
	</script>
	<script id="add-recipe-tag-template" type="text/x-custom-template">
		<tag>
			<input type="text" class="form-control" id="" placeholder="Tag">
		</tag>
	</script>
	<script id="recipe-modal-dialog-template" type="text/x-custom-template">
		<div class="modal" id="recipePopup">
  			<div class="modal-dialog">
    				<div class="modal-content">
      				<div class="modal-header">
        				<button type="button" class="close" id="closeDialog" onclick="closeModalPopup()" data-dismiss="modal" aria-hidden="true">×</button>
        				<h4 class="modal-title" id="recipeModalDialogTitle"></h4>
      				</div>
    	  			<div class="modal-body">
      				</div>
    			</div>
  			</div>
		</div>
	</script>
	<script id="add-recipe-template" type="text/x-custom-template">
		<div class="well bs-component">
		<form class="form-horizontal">
		  <fieldset>
		    <legend>Add Recipe</legend>
		    <div class="form-group">
		      <label for="inputTitle" class="col-md-2 control-label">Title</label>
		      <div class="col-md-10">
		        <input type="text" class="form-control" id="inputTitle" placeholder="Title">
		      </div>
		    </div>
		    <div class="form-group">
		      <label for="descTextArea" class="col-md-2 control-label">Description</label>
		      <div class="col-md-10">
		        <textarea class="form-control" rows="2" id="descTextArea"></textarea>
		        <span class="help-block">Enter a description of the recipe!</span>
		      </div>
		    </div>
			<div class="form-group">
		      <label for="inputIngredients" class="col-md-2 control-label">Ingredients</label>
		      <div class="col-md-7" id="ingredientsList">
				<ingredient>
					<div class="col-md-2">
						<input type="text" class="form-control" id="ingredientInput" placeholder="Ingredient">
					</div>
					<div class="col-md-2">				
						<input type="text" class="form-control" id="amountInput" placeholder="Amount">
					</div>
      				<div class="col-md-2">
        				<select id="measurementInput" class="form-control">
          					<option>Cup(s)</option>
          					<option>Ounce(s)</option>
          					<option>Pounds(s)</option>
          					<option>Tablespoon(s)</option>
          					<option>Teaspoon(s)</option>
							<option>Whole</option>
							<option>Pinch(s)</option>
        				</select>
    				</div>
				<ingredient>
			   <button type="button" class="btn btn-raised btn-info" id="addIngredient" onclick="addIngredientBox()">Add Ingredient</button>
			   <button type="button" class="btn btn-raised btn-warning" id="removeIngredient" onclick="removeLastIngredientBox()">Remove Ingredient</button>
		      </div>
		    </div>
		    <div class="form-group">
		      <label for="inputSteps" class="col-md-2 control-label">Steps</label>
		      <div class="col-md-6" id="stepsList">
				<textarea type="textArea" class="form-control" rows="10" id="Steps"></textarea>
				<span class="help-block">Enter the directions for cooking the recipe!</span>
		      </div>
		    </div>
			<div class="form-group">
      			<label for="inputFile" class="col-md-2 control-label">Add Picture</label>
      			<!--<div class="col-md-10">
        			<input type="text" readonly="" class="form-control" placeholder="Browse...">
        			<input type="file" id="inputFile" multiple="">
				</div>
				<div class="col-md-10">
      				<p> - or - </p>-->
					<div class="col-md-7">
						<input type="text" class="form-control" id="inputImagUrl" placeholder="Image URL">
					</div>
				<!--</div>-->
    		</div>
			<div class="form-group">
		      <label for="inputTags" class="col-md-2 control-label">Tags</label>
		      <div class="col-md-3" id="tagsList">
				<tag>
					<input type="text" class="form-control" id="" placeholder="Tag">
				</tag>
		      </div>
			  <button type="button" class="btn btn-raised btn-info" id="addTag" onclick="addTagBox()">Add Tag</button>
			  <button type="button" class="btn btn-raised btn-warning" id="addTag" onclick="removeLastTagBox()">Remove Tag</button>
		    </div>
			<div class="form-group">
		      <div class="col-md-10 col-md-offset-2">
		        <button type="button" class="btn btn-default" onclick="navHome()">Cancel</button>
		        <button type="submit" class="btn btn-primary" onclick="addRecipe()">Submit</button>
		      </div>
		    </div>
		  </fieldset>
		</form>
		<div>
	</script>
</body>
</html>