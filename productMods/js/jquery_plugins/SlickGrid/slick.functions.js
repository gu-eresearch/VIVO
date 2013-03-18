var sortcol = "title";
var sortdir = 1;
var percentCompleteThreshold = 0;
var searchString = "";

function requiredFieldValidator(value) {
	if (value == null || value == undefined || !value.length)
		return {valid:false, msg:"This is a required field"};
	else
		return {valid:true, msg:null};
}

function myFilter(item, args) {
	if (args.searchString != "" && item["title"].toLowerCase().indexOf(args.searchString.toLowerCase()) == -1) {
		return false;
	}

	return true;
}

function percentCompleteSort(a,b) {
	return a["title"] - b["title"];
}

function comparer(a,b) {
	var x = a[sortcol], y = b[sortcol];
	return (x == y ? 0 : (x > y ? 1 : -1));
}

function toggleFilterRow() {
	if ($(grid.getTopPanel()).is(":visible"))
		grid.hideTopPanel();
	else
		grid.showTopPanel();
}

function selectAll(){
	data2 = data2.concat(data);
	data.length = 0;    
	
	dataView2.setItems(data2);	
	
	refereshGrids();
}

function deSelectAll(){
	data = data.concat(data2);
	data2.length = 0;        	
	dataView.setItems(data);	
	refereshGrids();
}


function refereshGrids(){
	dataView.refresh();
	grid.render();
	
	dataView2.refresh();	
	grid2.render();
}