<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"
import = "java.util.List"
import=" com.amazonaws.services.autoscaling.model.AutoScalingGroup"
import=" com.amazonaws.services.autoscaling.model.Instance"
import=" com.amazonaws.auth.AWSCredentialsProvider"
import=" com.amazonaws.auth.ClasspathPropertiesFileCredentialsProvider"
import="com.amazonaws.services.autoscaling.AmazonAutoScalingClient"
import=" com.amazonaws.services.autoscaling.model.LaunchConfiguration"
import="com.amazonaws.services.ec2.model.AvailabilityZone"
import="com.amazonaws.services.ec2.AmazonEC2Client"
import="com.amazonaws.auth.BasicAWSCredentials"
import="java.util.ArrayList"
import="com.amazonaws.services.ec2.model.DescribeInstancesRequest"
import=" com.amazonaws.services.ec2.model.DescribeInstancesResult"
import=" com.amazonaws.services.ec2.model.Reservation"
import="com.amazonaws.services.autoscaling.model.DescribeAutoScalingGroupsRequest"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>AutoScaling Group</title>
<!-- Bootstrap -->
<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
<link href="css/table.css" rel="stylesheet" media="screen">

<style type="text/css">
body {
	padding-top: 60px;
	padding-bottom: 40px;
	font-family: Verdana, Geneva, sans-serif;
	
}
.scroll{

  height:330px;
  width:100%;
  
  overflow:auto;
}
.sidebar-nav {
	padding: 9px 0;
}
#maintable{
	table-layout: fixed;

}
</style>
<script src="http://code.jquery.com/jquery.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/helper.js"></script>

<script type="text/javascript">

function formSubmit(n){
	var form = document.getElementById("form");
	switch(n){
	case 1:
		form.action="CreateAutoScaling";
		break;
	case 2:
		if(confirm("Are you sure to delete?")){
			form.action="DeleteAutoScaling";
		}else{
			return;
		}
		break;
	case 3:
		form.action="editAutoScaling.jsp";
		break;
	case 4:
		if(confirm("Are you sure to terminate?")){
			form.action="TerminateInstance?msg=1";
		  }else{
			  return;
		  }
		break;
	case 5:
		if(confirm("Are you sure to terminate?")){
			form.action="TerminateInstance?msg=2";
		  }else{
			  return;
		  }
		break;
	case 6:
		form.action = "groupcommand.jsp";
		break;
	}
	form.submit();
}


</script>
</head>
<body>
<%
BasicAWSCredentials basicAWSCredentials = (BasicAWSCredentials)session.getAttribute("AWSCredentials");
//BasicAWSCredentials basicAWSCredentials = new BasicAWSCredentials("AKIAJR3XOWMQKVZXHOYQ","1L7iMWoKktZx9ZqAjBQx8JajA9BDVwJtVSf6GX1T");
AmazonAutoScalingClient client = new AmazonAutoScalingClient(basicAWSCredentials);
List<LaunchConfiguration> configs = client.describeLaunchConfigurations().getLaunchConfigurations();
List<AutoScalingGroup> groups = client.describeAutoScalingGroups().getAutoScalingGroups();
AmazonEC2Client ec2Client = new AmazonEC2Client(basicAWSCredentials);
List<AvailabilityZone> zones= ec2Client.describeAvailabilityZones().getAvailabilityZones();
String deleteASG = (String)session.getAttribute("deleteASG");

if(deleteASG!=null){
 out.println("<script>alert(\""+deleteASG+"\")</script>");
 session.setAttribute("deleteASG",null);
}
String delInstance = (String)session.getAttribute("delInstance");
if(delInstance!=null){
	 out.println("<script>alert(\""+delInstance+"\")</script>");
	 session.setAttribute("delInstance",null);
	}
%>

<script type="text/javascript">
function checkASG(){
	var asgName = document.getElementById("groupname").value;
	if(asgName==""){
		 alert("Name cannot be empty");
		 return;
	}
	<% for(AutoScalingGroup asg : groups){%>
	  var name = "<%=asg.getAutoScalingGroupName()%>";
	   if(asgName == name){
		   alert("Name existed, choose another name!");
		   return;
	   }
	<%}%>
	
	var zones=document.getElementsByName("zones");
	var count=0;
	for(var i=0;i<zones.length;i++){
		if(zones[i].checked){
			count = count+1;
		}
	}
	if(count == 0){
		alert("Please choose at least Availability Zone !");
		return;
	}
	
	var max = document.getElementById("max").value;
	var min = document.getElementById("min").value;
	var desired = document.getElementById("desired").value;
	
	if(max==""||min==""){
		alert("Maxsize or Minsize cannot be empty !");
		return;
	}
	if(isNaN(max)||isNaN(min)||isNaN(desired)){
		alert("Maxsize or Minsize or Desired Capacity should be number !");
		return;
	}
	
	if(parseInt(max)<parseInt(min)){
		alert("Maxsize should be greater than Minsize !");
		return;
	}
	
	if(parseInt(max)<parseInt(desired)){
		alert("Maxsize should be greater than Desired Capacity!");
		return;
	}
	
	if(parseInt(desired)<parseInt(min)){
		alert("Desired Capacity should be greater than Minsize !");
		return;
	}
	
	var graceperiod = document.getElementById("graceperiod").value;
	var cooldown = document.getElementById("cooldown").value;
	if(isNaN(graceperiod)){
		alert("Health Check Grace Period should be number !");
		return;
	}
	if(isNaN(cooldown)){
		alert("Default Cool Down should be number !");
		return;
	}
    
	form = document.getElementById("form");
	form.action="CreateAutoScaling";
	form.submit();
	
}

</script>
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
		  <div class="well" style="height:600px">
			<ul class="nav nav-list">
				<li>
					<h5>ASG Dashboard</h5>
				</li>
				<li class="divider"></li>
				<li><a href="launchconfig.jsp" style="color:black">Launch Configurations</a></li>
				<li class="active"><a href="autoscaling.jsp" style="color:white">AutoScaling Groups</a></li>
				<li><a href="scalingpolicy.jsp" style="color:black">Scaling Policies</a></li>
			</ul>
		  </div>
		</div>
		
		<div class="span10">
		<form id="form" method="post">
		  <a href="#autoscaling" role="button" class="btn" data-toggle="modal"><b>Create AutoScaling Group</b></a>
		  <!-- model1 -->
		  <div id="autoscaling" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel2" aria-hidden="true">
			<div class="modal-header">
   			  <h3 id="myModalLabel2" align="center">AutoScaling</h3>
  			</div>
  			<div class="modal-body">
  		    <table cellpadding=5>
  			  <tr>
  			    <td align="right">Group name: *</td>
  			    <td><input type="text" name="groupname" id="groupname"></td>
  			  </tr>
  			  <tr>
  			    <td align="right">Launch Configuration: *</td>
  			    <td><select name="launchconfig">
  			        <%for(LaunchConfiguration lc: configs) { %>
    	            <option><%=lc.getLaunchConfigurationName() %></option>
    	           <%} %>
    	           </select>
    	        </td>
  			  </tr>
  			  <tr>
  			    <td align="right">Availability Zone: *</td>
  			    <td>  
  			    <%for(AvailabilityZone az:zones) {%>
  			      <input type="checkbox" name="zones" value=<%=az.getZoneName() %>>&nbsp;<%=az.getZoneName() %><br>
  			    <%} %>
  			    </td>
  			  </tr>
  			  <tr>
  			    <td align="right">Instance number:</td>
  			    <td>Max*:&nbsp;<input type="text" style="width:40px;margin-right:5px" name="maxsize" id="max">
  			        Min*:&nbsp;<input type="text" style="width:40px;margin-right:5px" name="minsize" id="min">
  			        Desired:&nbsp;<input type="text" style="width:40px;margin-right:5px" name="capacity" id="desired">
  			    </td>
  			  </tr>
  			 
  			  <tr>
  			    <td align="right">Health Check Type:</td>
  			    <td>
  			      <input type="radio" name="healthchecktype" value="EC2" checked>&nbsp;Amazon EC2&nbsp;&nbsp;
  			      <input type="radio" name="healthchecktype" value="ELB">&nbsp;Elastic Load Balancer
  			    </td>
  			  </tr>
  			  <tr>
  			    <td align="right"> Health Check Grace Period: </td>
  			    <td><input type="text" name="graceperiod" id="graceperiod" style="width:60px;margin-right:10px" value="600">seconds</td>
  			  </tr>
  			 <tr>
  			    <td align="right">Default Cool Down: </td>
  			    <td><input type="text" name="cooldown" id="cooldown" style="width:60px;margin-right:10px" value="300">seconds</td>
  			  </tr>
  			  <tr>
  			    <td align="right">Termination Policy:</td>
  			    <td>
  			      <select name="terminationpolicy">
  			        <option>Default</option>
  			        <option>OldestInstance </option>
  			        <option>NewestInstance </option>
  			        <option>OldestLaunchConfiguration </option>
  			        <option>ClosestToNextInstanceHour </option>
  			      </select>
  			    </td>
  			  </tr>
  			</table>
  			</div>
 		    <div class="modal-footer">
  		      <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
     		  <button class="btn btn-primary" type="button" onclick="checkASG()">Create</button>
  			</div>
		  </div>

		   <div style="margin-left:5px"class="btn-group">
		     <button class="btn dropdown-toggle" data-toggle="dropdown" id="del" disabled >
		       <b>Action</b>
		       <span class="caret"></span>
		     </button>
		     <ul class="dropdown-menu">
		       <li><a href="#" onclick="formSubmit(2)">Delete AutoScaling Group</a></li>
		       <li><a href="#" onclick="formSubmit(3)">Edit AutoScaling Group</a></li>
		       <li><a href="#" onclick="formSubmit(6)">Enter Command</a></li>
		     </ul>
		     
		   </div>
		 
		  
		     <a style="margin-left: 10px" class="btn pull-right" href="#setting" data-toggle="modal"><i class="icon-cog"></i></a>
		     <!-- model2 -->
		  <div id="setting" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-header">
   			  <h4 id="myModalLabel" align="center">Show/Hide Columns</h4>
  			</div>
  			<div class="modal-body" >
  			<h5>AutoScaling Group Attributes:</h5>
  			<table cellpadding=10>
  			  <tr>
  			    <td width="180px"><input type="checkbox" name="setCheckbox" style="margin:5px" checked/>Name</td>
  			    <td width="200px"><input type="checkbox" name="setCheckbox" style="margin:5px" checked/>Launch Configuration</td>
  			    <td width="180px"><input type="checkbox" name="setCheckbox" style="margin:5px" checked/>Availability Zone</td>
  			  </tr>
  			  <tr>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>Max</td>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>Min</td>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>Desired</td>
  			  </tr>
  			  <tr>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>Health Check Type</td>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>Health Check Grace Period</td>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>Instances</td>
  			  </tr>
  			  <tr>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>Termination Policy</td>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>Cooldown</td>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>Created</td>
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
		   <table id="maintable" class="maintable" width=80% border="1" style="margin:0px">
		    <thead>
		     <tr align="center" >
		       <th width="25px"><input type="checkbox" onclick="selectAll('checkbox1','del')"></th>
		       <th width="150px">Name</th>
		       <th width="180px">Launch Configuration</th>
		       <th width="150px">Availability Zone</th>
		       <th width="40px">Max</th>
		       <th width="40px">Min</th>
		       <th width="50px">Desired</th>
		       <th width="130px">Health Check Type</th>
		       <th width="110px">Check Period(s)</th>
		       <th width="160px">Instances</th>
		       <th width="130px">Termination Policy</th>
		       <th width="100px">Cooldown(s)</th>
		       <th width="200px">Created</th>
		     </tr>
		     </thead>
		     <tbody>
		     <%for(AutoScalingGroup asg : groups ){ %>
		     <tr align="center" >
		   
		     <td><input type="checkbox" name="checkbox1" onclick="activeDel('checkbox1','del')" value=<%=asg.getAutoScalingGroupName() %> >
		     </td>
		     <td><%=asg.getAutoScalingGroupName() %></td>
		     <td><%=asg.getLaunchConfigurationName() %></td>
		      <td><%for(String zone:asg.getAvailabilityZones()){
		    	     out.print(zone+"; ");
		           }
		    	 %>
		     </td>
		     <td><%=asg.getMaxSize() %></td>
		     <td><%=asg.getMinSize() %></td>
		     <td><%=asg.getDesiredCapacity() %></td>
		     <td><%=asg.getHealthCheckType() %></td>
		     <td><%=asg.getHealthCheckGracePeriod() %></td>
		     <td><%for(Instance instance:asg.getInstances()){ 
		    	 out.print(instance.getInstanceId()+"; ");
		     }
		     %>
		     </td>
		     <td><%=asg.getTerminationPolicies() %></td>
		     <td><%=asg.getDefaultCooldown() %></td>
		     <td><%=asg.getCreatedTime() %></td>
		     </tr>
		   <%} %>
		     </tbody>
		   </table>
		  </div>
		  <br>
		  <b>Viewing:</b>
		    <div style="margin-left:10px"class="btn-group">
		     <button class="btn dropdown-toggle" data-toggle="dropdown" id="del2" disabled >
		       <b>Action</b>
		       <span class="caret"></span>
		     </button>
		     <ul class="dropdown-menu">
		       <li><a href="#" onclick="formSubmit(4)">Terminate</a></li>
		       <li><a href="#" onclick="formSubmit(5)">Terminate and decrement descried capacity</a></li>
		     </ul>
		   </div>
		      <hr style="margin-top:10px" color="#C0C0C0" size=1>
		 &nbsp;Click the Instance to Connect
		
	
		   <div class="scroll">
		   <table class="maintable"  style="margin:0px" border=1>
		  
		     <tr align="center" style="font-weight:bold" height="30px">
		       <th width="30px"><input type="checkbox" onclick="selectAll('checkbox2','del2')"></th>
		       <th width="160px">Instance</th>
		       <th width="120px">AMI</th>
		       <th width="120px">State</th>
		       <th width="160px">AutoScaling Group</th>
		       <th width="180px">Launch Configuration</th>
		       <th width="140px">Private IP</th>
		       <th width="140px">Public IP</td>
		     </tr>
		     <%
		     DescribeInstancesRequest describeInstanceRequest ;
		     DescribeInstancesResult result;
		     for(AutoScalingGroup group:groups){
		    	 for(Instance instance: group.getInstances()){
		     %>

		     <tr align="center">
		     <td width="30px"> 
		     <%if(instance.getLifecycleState().equals("InService")) {%>
		     <input type="checkbox" name="checkbox2" onclick="activeDel('checkbox2','del2')" value=<%=instance.getInstanceId() %>>
		     <%}else{ %>
		      <input type="checkbox" name="checkbox2" onclick="activeDel('checkbox2','del2')" value=<%=instance.getInstanceId()%> disabled>
		      <%} %>
		     <input type="hidden" name="autogroup" value=<%=group.getAutoScalingGroupName() %> > 
		     </td>
		      <%describeInstanceRequest= new DescribeInstancesRequest().withInstanceIds(instance.getInstanceId());
		     result = ec2Client.describeInstances(describeInstanceRequest);%>
		     <td><a href="command.jsp?instance=<%=instance.getInstanceId() %>&dns=<%=result.getReservations().get(0).getInstances().get(0).getPublicDnsName() %>" >
		     <%=instance.getInstanceId() %></a></td>
		     <td><%=instance.getAvailabilityZone() %></td>
		     <td><%=instance.getLifecycleState() %></td>
		     <td><%=group.getAutoScalingGroupName() %></td>
		     <td><%=instance.getLaunchConfigurationName() %></td>
		     <td><%=result.getReservations().get(0).getInstances().get(0).getPrivateIpAddress()%> </td>
		     <td><%=result.getReservations().get(0).getInstances().get(0).getPublicIpAddress()%> </td>	
		     </tr>
		   <%} }%>
		     
		   </table>
		  </div>
	 	</form>
	 	
	 	</div>
	  </div>
	</div> 
	
		

	
</body>
</html>