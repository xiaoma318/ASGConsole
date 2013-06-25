function showAbout(){
	alert("NI AutoScaling Concole Version 1.0");
}

function showContact(){
	alert("Email: xxx@gmail.com\nPhone: 713-555-xxx\nAddress: 11500 N MO Pac Expy, Austin, TX 78759");
}

function selectAll(objName,buttonId){
	var checkboxs = document.getElementsByName(objName);
	var delButton = document.getElementById(buttonId);
	for(var i=0;i<checkboxs.length;i++){
		var e = checkboxs[i];
		e.checked = !e.checked;
	}
	delButton.disabled = !delButton.disabled;
}

function activeDel(objName,buttonId){
	var checkboxs = document.getElementsByName(objName);
	var delButton = document.getElementById(buttonId);
	var count = 0;
	for(var i = 0; i < checkboxs.length; i++){
		if(checkboxs[i].checked)
			count = count +1;
	}
	if(count == 0)
		delButton.disabled = true;
	else
		delButton.disabled = false;
}

function selectAtts(){
	 var rows = document.getElementById('maintable').rows;
	 var atts = document.getElementsByName("setCheckbox");
	 
	    for (var row = 0; row < rows.length; row++) {
	        var cols = rows[row].cells;
	        for(var i =0;i<atts.length;i++){
	        	if(atts[i].checked){
	        		cols[i+1].style.display="";
	        	}else{
	        		cols[i+1].style.display="none";
	        	}
	        }
	    }
}

function active(){
	var obj = document.getElementById("minstep");
	obj.disabled = false;
}
function disable(){
	var obj = document.getElementById("minstep");
	obj.disabled = true;
}

