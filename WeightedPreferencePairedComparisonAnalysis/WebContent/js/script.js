/* **********************************
 * Author: William Pegg
 * Date: 2/20/2014
 * Description: This is the file which incorporates the various necessary
 *              plugins and performs the functions of the site.
 * **********************************/
var app = angular.module("main", []);

app.controller("TableCtrl",function ($scope) {

$('#alertDiv').hide();

var _testOptions = localStorage.getItem('optionsArray');
var _testTable = localStorage.getItem('tableArray');
var _testElements = localStorage.getItem('tableElementsArray');
var _testValues = localStorage.getItem('weightedValuesArray');

if(_testOptions != '' && _testOptions != null){$scope.options = JSON.parse(_testOptions);}
else{$scope.options = [];}
if(_testTable != '' && _testTable != null){$scope.table = JSON.parse(_testTable);}
else{$scope.table=[];}
if(_testValues != '' && _testValues != null){$scope.weighted_values = JSON.parse(_testValues);}
else{$scope.weighted_values=[];}


for(var i=0; i<=$scope.options.length-1;i++)
{delete $scope.options[i].$$hashKey;}

for(var i=0; i<=$scope.options.length-1;i++)
{for(var j=0; j<=$scope.table.length-1;j++){delete $scope.table[i][j].$$hashKey;}}

for(var i=0; i<=$scope.weighted_values.length-1;i++)
{delete $scope.weighted_values[i].$$hashKey;}

// Item List Arrays
$scope.selected_elements=[];
$scope.table_elements=[];

$scope.reset = function(){
	$('#alertDiv').fadeOut("slow");
	$('#message').text('');
	
	$scope.selected_elements=[];
	$scope.table_elements=[];
	$scope.options = [];
	$scope.table=[];
	$scope.weighted_values=[];
	
	localStorage.setItem('optionsArray',JSON.stringify($scope.options));
	localStorage.setItem('tableElementsArray',JSON.stringify($scope.table_elements));
	localStorage.setItem('tableArray',JSON.stringify($scope.table));
	localStorage.setItem('weightedValuesArray',JSON.stringify($scope.weighted_values));
};

/*$scope.removeOption = function(element,index){
	$('#alertDiv').fadeOut("slow");
	$('#message').text('');
	
	if($scope.options.length <= 3)
	{$scope.sendalert('Can not have less than three options.');}
	else
	{
		$scope.options.splice(index,1);
		$scope.table.splice(index,1);
		$scope.weighted_values.splice(index,1);
		
		for(var i=0;i<=$scope.table.length-1;i++)
		{$scope.table[i].splice(index+1,1);}
		
		localStorage.setItem('optionsArray',JSON.stringify($scope.options));
		localStorage.setItem('tableElementsArray',JSON.stringify($scope.table_elements));
		localStorage.setItem('tableArray',JSON.stringify($scope.table));
		localStorage.setItem('weightedValuesArray',JSON.stringify($scope.weighted_values));
	}
};*/

// Add a Item to the list
$scope.addItem = function () {
	$('#alertDiv').fadeOut("slow");
	$('#message').text('');
	
	if(angular.isUndefinedOrNull( $scope.optName))
	{$scope.sendalert('Please Enter An Option.');}
	else if($scope.optName === '')
	{$scope.sendalert('Please Enter An Option.');}
	else
	{
		var _optNameCheck = $scope.optName;
		var _exists = false;
		
		for(var i=0;i<$scope.options.length;i++)
		{
			if(_optNameCheck === $scope.options[i].optionName)
			{_exists=true;}
		}

	    if($scope.options.length >= 8)
	    {$scope.sendalert('You can one add up to eight options.');}
	    else if($scope.options.length === null)
	    {$scope.sendalert('You can one add up to eight options.');}
	    else if(_exists)
	    {$scope.sendalert('Option already exists. Please try again.');}
	    else
	    {
	    	$scope.table_elements=[];
	    	
	    	$scope.options.push({optionName: $scope.optName});
	    	$scope.weighted_values.push({optionName: $scope.optName,count:0});
	    	
	    	if($scope.options.length <= 8)
	    	{
	    		$scope.table_elements.push({element:$scope.optName});
	    		for(var i=0;i<=($scope.options.length)-1;i++)
	    		{
	    			var _randId = Math.floor((Math.random()*250682)+1);
	    			
	    			$scope.table_elements.push({className:'Disabled',element:'',id:_randId});
	    		}
	    		
	    		$scope.table.push($scope.table_elements);
	    		
	    		for(var j=0;j<=($scope.options.length)-2;j++)
    			{
    				for(var k=0;k<($scope.options.length)-1;k++)
	    			{
    					var _randId = Math.floor((Math.random()*250682)+26485);
    					
    					if($scope.table[j].length <= $scope.options.length)
    					{$scope.table[j].push({className:'Enabled',element:'',id:_randId});}
	    			}
    			}	
	    	}	    
	    }
	}
    
	localStorage.setItem('optionsArray',JSON.stringify($scope.options));
	localStorage.setItem('tableElementsArray',JSON.stringify($scope.table_elements));
	localStorage.setItem('tableArray',JSON.stringify($scope.table));
	localStorage.setItem('weightedValuesArray',JSON.stringify($scope.weighted_values));
	
    // Clear input fields after push
    $scope.optName = "";
};

$scope.elementClicked = function(selection,element,index){
	if(selection === 'Enabled')
	{
		var _sideParent = element.currentTarget.parentElement.childNodes[2].innerText;
		var _topParent = element.currentTarget.offsetParent.childNodes[1].firstElementChild.cells[index].innerText;
		$scope.selected_elements.push(element);
		var _t = index;
		var _prevElement = element.currentTarget.innerText;
		var _prevElementId = element.currentTarget.id;
		
		$('#main')
			.append(
				$('<div/>')
					.attr({'id':'elementRate'})
					.append($('<label/>').text('Which option is more important to you?'))
					.append(
						$('<div/>')
							.append(
								$('<select/>')
									.attr('id','userOptionSelection')
									.append($('<option/>').attr('id','option1').val(1).text(_sideParent))
									.append($('<option/>').attr('id','option2').val(2).text(_topParent))
							)
					)
					.append(
						$('<div/>')
							.append($('<label/>').text('How important is this option?'))
							.append(
								$('<select/>')
									.attr('id','differenceSelector')
									.append($('<option/>').val('1').text('1-Not Important'))
									.append($('<option/>').val('2').text('2-Not Too Important'))
									.append($('<option/>').val('3').text('3-Important'))
									.append($('<option/>').val('4').text('4-Slightly More Important'))
									.append($('<option/>').val('5').text('5-Very Important'))
							)
					)
					.append(
						$('<div/>')
							.append(
								$('<button/>')
									.attr('id','submitChoiceButton')
									.text('Submit')
									.click(function(){										
										var _selectedOption = $('#userOptionSelection').val();
										var _selectedWeight = $('#differenceSelector').val();
										var _tempIndex = -1;
										var _tempWeight = 0;
										var _previous = _prevElement.substr(0,(_prevElement.search(',')));;
										var _newCount=0;
										var _prevWeight=_prevElement.substr((_prevElement.search(','))+1,1);
										var _len = $scope.selected_elements.length;
										var _selectedCell = $scope.selected_elements[_len-1];
										var _elementId = ''
											
										if(_selectedCell.srcElement.offsetParent.id != '' && _selectedCell.srcElement.id === '') 
										{_elementId = _selectedCell.srcElement.offsetParent.id;}
										else if(_selectedCell.srcElement.id != '' && _selectedCell.srcElement.offsetParent.id === '')
										{_elementId = _selectedCell.srcElement.id;}
										else
										{_elementId ='';}
										
										if(_selectedOption === '1')
										{_selectedOption = $('#option1').text(); _tempIndex=_t-2;}
										else
										{_selectedOption = $('#option2').text(); _tempIndex=_t-1;}
										
										if(_selectedWeight === '1')
										{_selectedWeight = '1 - Not Important'; _tempWeight=1;}
										else if(_selectedWeight === '2')
										{_selectedWeight = '2 - Not Too Important';_tempWeight=2;}
										else if(_selectedWeight === '3')
										{_selectedWeight = '3 - Important';_tempWeight=3;}
										else if(_selectedWeight === '4')
										{_selectedWeight = '4 - Slightly More Important';_tempWeight=4;}
										else
										{_selectedWeight = '5 - Very Important';_tempWeight=5;}
										
										var _prevTempIndex=-1;
										var _curTempIndex=-1;
										
										for(var i=0;i<$scope.weighted_values.length;i++)
										{
											if($scope.weighted_values[i].optionName === _previous)
											{_prevTempIndex=i;}
											if($scope.weighted_values[i].optionName === _selectedOption)
											{_curTempIndex=i;}
										}
										
										for(var j=0;j<=($scope.options.length)-1;j++)
						    			{
						    				for(var k=0;k<=($scope.options.length);k++)
							    			{
						    					if(''+$scope.table[j][k].id === _elementId)
						    					{$scope.table[j][k].element=_selectedOption+','+_selectedWeight}
							    			}
						    			}	
										
										if(_prevElement === '')
										{$scope.weighted_values[_curTempIndex].count += _tempWeight;}
										else
										{ 
											if(_elementId === _prevElementId)
											{
												$scope.weighted_values[_prevTempIndex].count = ($scope.weighted_values[_prevTempIndex].count-_prevWeight);
												$scope.weighted_values[_curTempIndex].count = $scope.weighted_values[_curTempIndex].count+_tempWeight;
											}
											else
											{/*do nothing*/}
										}
										$scope.$apply()
										
										localStorage.setItem('optionsArray',JSON.stringify($scope.options));
										localStorage.setItem('tableElementsArray',JSON.stringify($scope.table_elements));
										localStorage.setItem('tableArray',JSON.stringify($scope.table));
										localStorage.setItem('weightedValuesArray',JSON.stringify($scope.weighted_values));
										
										$('#elementRate').dialog('destroy').remove();
									})
							)
					)
			);
		$('#elementRate').dialog();
	}
}

angular.isUndefinedOrNull = function(configId){ return angular.isUndefined(configId) || configId === null};

$scope.sendalert = function(message){
	$('#message').text(message);
	$('#closeAlert').click(function(){$('#alertDiv').fadeOut("slow");$('#message').text('');});
	$('#alertDiv').show();
};

});