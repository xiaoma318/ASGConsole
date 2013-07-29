<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"
import = "java.util.List"
import=" com.amazonaws.services.autoscaling.model.AutoScalingGroup"
import=" com.amazonaws.auth.AWSCredentialsProvider"
import=" com.amazonaws.auth.ClasspathPropertiesFileCredentialsProvider"
import="com.amazonaws.services.autoscaling.AmazonAutoScalingClient"
import="com.amazonaws.services.autoscaling.model.ScalingPolicy"
import="com.amazonaws.auth.BasicAWSCredentials"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Scaling Policy</title>
<!-- Bootstrap -->
<link href="css/bootstrap.css" rel="stylesheet" media="screen">
<link href="css/table.css" rel="stylesheet" media="screen">
<style type="text/css">
body {
	padding-top: 60px;
	padding-bottom: 40px;
	font-family: Verdana, Geneva, sans-serif;
}
.scroll{

  height:400px;
  width:100%;
  overflow:auto;
}
.sidebar-nav {
	padding: 9px 0;
}


</style>
<script src="http://code.jquery.com/jquery.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/helper.js"></script>
<script type="text/javascript">
function formSubmit(n){
	form = document.getElementById("form");
	switch(n){
	case 1:
		form.action="PutScalingPolicy";
		break;
	case 2:
		if(confirm("Are you sure to delete?")){
			form.action="DeleteScalingPolicy";
		}else{
			return;
		}
		break;
	case 3:
		form.action="editPolicy.jsp";
		break;
	case 4:
		form.action="ExecutePolicy";
		break;
	}
	form.submit();
}
function checkSC(){
	var policyname = document.getElementById("policyname").value;
	if(policyname==""){
		alert("Name cannot be empty !");
		return;
	}
	
	var adjustment = document.getElementById("adjustment").value;
	if(isNaN(adjustment) || adjustment==""){
		alert("Adjustment should be number !");
		return;
	}
	var form = document.getElementById("form");
	form.action="PutScalingPolicy";
	form.submit();
}

</script>
</head>
<body>
<%
//BasicAWSCredentials basicAWSCredentials = (BasicAWSCredentials)session.getAttribute("AWSCredentials");
BasicAWSCredentials basicAWSCredentials = new BasicAWSCredentials("AKIAJR3XOWMQKVZXHOYQ","1L7iMWoKktZx9ZqAjBQx8JajA9BDVwJtVSf6GX1T");
AmazonAutoScalingClient client = new AmazonAutoScalingClient(basicAWSCredentials);
List<ScalingPolicy> policies = client.describePolicies().getScalingPolicies();
List<AutoScalingGroup> groups = client.describeAutoScalingGroups().getAutoScalingGroups();
%>
<%
String msg=request.getParameter("msg");

if(msg!=null && msg.equals("1")){%>
	<script>alert("Successfully execute policies")</script>
<%} %>

	<div class="navbar navbar-inverse navbar-fixed-top">
		<div class="navbar-inner">
			<div class="container-fluid">
				<a class="brand" href="#">AutoScaling</a>
				<ul class="nav">
					<li><a href="home.jsp">Home</a></li>
					<li><a href="#about">About</a></li>
					<li><a href="#contact">Contact</a></li>
				</ul>
				<ul class="nav pull-right">
					<li><a href = "login.jsp" > Log out</a></li>
				</ul>
			</div>
		</div>
	</div>

	<div class="container-fluid">
	  <div class="row-fluid">
		<div class="span2">
		  <div class="well" style="height:600px ">
			<ul class="nav nav-list">
				<li>
					<h5>ASG Dashboard</h5>
				</li>
				<li class="divider"></li>
				<li><a href="launchconfig.jsp" style="color:black">Launch Configurations</a></li>
				<li><a href="autoscaling.jsp" style="color:black">AutoScaling Groups</a></li>
				<li class="active"><a href="scalingpolicy.jsp" style="color:white">Scaling Policies</a></li>
			</ul>
		  </div>
		</div>
		
		<div class="span10">
		<form id="form" method="post">
		
		  <a href="#scalingpolicy" role="button" class="btn" data-toggle="modal"><b>Create Scaling Policy</b></a>
		  
		  <!-- model -->
		  <div id="scalingpolicy" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel3" aria-hidden="true">
			<div class="modal-header">
   			  <h3 id="myModalLabel3" align="center">Scaling Policy</h3>
  			</div>
  			<div class="modal-body">
  			<table class="table1">
  			  <tr>
  			    <td align="right">Name: </td>
  			    <td><input type="text" name="policyname" id="policyname"></td>
  			  </tr>
  			  <tr>
  			    <td align="right">AutoScaling Group: </td>
  			    <td><select name="groupname">
  			        <%for(AutoScalingGroup asg:groups){ %>
  			        <option><%=asg.getAutoScalingGroupName() %></option>
  			        <%} %>
  			    </select>
  			    </td>
  			  </tr>
  			  <tr>
  			    <td align="right">Adjustment: </td>
  			    <td><input type="text" name="adjustment" id="adjustment"></td>
  			  </tr>
  			  <tr>
  			    <td align="right">Adjustment Type: </td>
  			    <td>  
  			      <select name="adjustmenttype" id='adjustmenttype' onclick="checkAdjustment()">
    	            <option value="ChangeInCapacity">ChangeInCapacity</option>
    	            <option value="ExactCapacity">ExactCapacity</option>
    	            <option value="PercentChangeInCapacity">PercentChangeInCapacity</option>
    	          </select>
  			    </td>
  			  </tr>
  			   <tr>
  			    <td align="right">Min Adjustment Step: </td>
  			    <td><input type="text" name="minadjustmentstep" id="minstep" disabled></td>
  			  </tr>
  			  <tr>
  			    <td align="right">Cooldown(s):</td>
  			    <td><input type="text" name="cooldown"></td>
  			  </tr>
  			  
  			</table>
  			</div>
 		    <div class="modal-footer">
  		      <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
     		  <button class="btn btn-primary" type="button" onclick="checkSC()">Create</button>
  			</div>
		  </div>

		   <div style="margin-left:5px"class="btn-group">
		     <button class="btn dropdown-toggle" data-toggle="dropdown" id="del" disabled >
		       <b>Action</b>
		       <span class="caret"></span>
		     </button>
		     <ul class="dropdown-menu">
		       <li><a href="#" onclick="formSubmit(2)">Delete Scaling Policy</a></li>
		       <li><a href="#" onclick="formSubmit(3)">Edit Scaling Policy</a></li>
		       <li><a href="#" onclick="formSubmit(4)">Execute Scaling Policy</a></li>
		     </ul>
		     
		   </div>
		  
		     <a style="margin-left: 10px" class="btn pull-right" href="#setting" data-toggle="modal"><i class="icon-cog"></i></a>
		     <!-- model2 -->
		  <div id="setting" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-header">
   			  <h4 id="myModalLabel" align="center">Show/Hide Columns</h4>
  			</div>
  			<div class="modal-body" style="margin-left:20px">
  			<h5>Scaling Policy Attributes:</h5>
  			<table cellpadding=10>
  			  <tr>
  			    <td width="200px"><input type="checkbox" name="setCheckbox" style="margin:5px" checked/>Name</td>
  			    <td width="200px"><input type="checkbox" name="setCheckbox" style="margin:5px" checked/>Group Name</td>
  			    <td width="200px"><input type="checkbox" name="setCheckbox" style="margin:5px" checked/>Scaling Adjustment</td>
  			  </tr>
  			  <tr>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>Adjustment Type</td>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>Cooldown</td>
  			  </tr>
  			</table>
  			</div>
  	       <div class="modal-footer">
  		      <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
     		  <button class="btn btn-primary" type="button" onclick="selectAtts()" data-dismiss="modal" aria-hidden="true">Apply</button>
  			</div>
		  </div>
		   <a class="btn pull-right" href="#"  onclick="location.reload()"><i class="icon-refresh"></i></a>
		   
		   <hr style="margin-top:10px" color="#C0C0C0" size=1>
		   
		   <div class="scroll">
		   <table id="maintable" width="1000px" class="maintable" style="table-layout:fixed;margin:0px" border=2 cellpadding=2>
		     <tr align="center" style="font-weight:bold" height="30px">
		       <th width="30px"><input type="checkbox" onclick="selectAll('checkbox','del')"></th>
		       <th width="180px">Name</th>
		       <th width="160px">Group Name</th>
		       <th width="150px">Scaling Adjustment</th>
		       <th width="200px">Adjustment Type</th>
		       <th width="150px">Cooldown(s)</th>
		     </tr>
		     
		     <%for(ScalingPolicy sc: policies){%>
		     <tr align="center">
		     <td><input type="checkbox" name="checkbox" value=<%=sc.getPolicyName()+";"+sc.getAutoScalingGroupName() %> onclick="activeDel('checkbox','del')">
		     
		     </td>
		     <td><%=sc.getPolicyName() %></td>
		     <td><%=sc.getAutoScalingGroupName() %></td>
		     <td><%=sc.getScalingAdjustment() %></td>
		     <td><%=sc.getAdjustmentType() %></td>
		     <td><%=sc.getCooldown() %>
		     </tr>
		     <%} %>
		     
		   </table>
		  </div>
		  </form>
		  
	 	</div>
	  </div>
	</div> 
		  
		

	
</body>
</html>