function setActiveStyleSheetTextTitle(title) {

  var i, j, a, main;
  for(i=0; (a = document.getElementsByTagName("link")[i]); i++) {
    if(a.getAttribute("rel").indexOf("style") != -1 && a.getAttribute("title") && a.getAttribute("title").indexOf("text") > -1) {
     a.disabled = true;
      if(a.getAttribute("title") == title) {
        a.disabled = false;
        for(j=0; j < textstyles.length ; j++) {
          if(textstyles[j] == title){
            styleindex = j;
            createCookie("text-size", styleindex, 365);
          }
        }
      }  
    }
  }
}

function setActiveStyleSheetText(indexchange) {
	
		
  styleindex = parseInt(styleindex) + indexchange;
  if(styleindex < 0){
  	styleindex = 0;
  } else if(styleindex >= textstyles.length){
  	styleindex = textstyles.length - 1;
  }	
  
  createCookie("text-size", styleindex, 365);
  
  var title = textstyles[styleindex];
 
  var i, a, main;

  $('body').removeClass();
  $('body').addClass(title);
  
  
  for(i=0; (a = document.getElementsByTagName("link")[i]); i++) {
    if(a.getAttribute("rel").indexOf("style") != -1 && a.getAttribute("title") && a.getAttribute("title").indexOf("text") > -1) {
      a.disabled = true;
      if(a.getAttribute("title") == title) a.disabled = false;}
  }
  return null;
}

function getActiveStyleSheetText() {
	return styleindex;}

function getPreferredStyleSheetText() {
	return 2;} 

function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();}
	else expires = "";
	document.cookie = name+"="+value+expires+"; path=/;domain=griffith.edu.au";}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);}
	return null;}

function textSwitcherLoad() {
	var textcookie = readCookie("text-size");
	
	if (textcookie != "NaN"){
	var texttitle = textcookie ? textcookie : getPreferredStyleSheetText();
	var styleindex = texttitle;
	setActiveStyleSheetText(0);
	} else {
		createCookie("text-size", 0, 365);	
		var textcookie = readCookie("text-size");
		
		var texttitle = textcookie ? textcookie : getPreferredStyleSheetText();
		var styleindex = texttitle;
		setActiveStyleSheetText(0);
		
	}
}


function textSwitcherUnLoad() {
	var title = getActiveStyleSheetText();
	createCookie("text-size", title, 365);
	var title = getActiveStyleSheetTheme();
	//createCookie("device", title, 365);
}

//addUnLoadEvent(textSwitcherUnLoad);
//var styleindex;
var textstyles=new Array("text-decrease2","text-decrease1","text-standard","text-increase1","text-increase2");

var textcookie = readCookie("text-size");
var texttitle = textcookie ? textcookie : getPreferredStyleSheetText();
var styleindex = texttitle;
//textSwitcherLoad();
