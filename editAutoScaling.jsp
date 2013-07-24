<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"
import = "java.util.List"
import=" com.amazonaws.services.autoscaling.model.Instance"
import=" com.amazonaws.auth.AWSCredentialsProvider"
import=" com.amazonaws.auth.ClasspathPropertiesFileCredentialsProvider"
import="com.amazonaws.services.autoscaling.AmazonAutoScalingClient"
import=" com.amazonaws.services.autoscaling.model.LaunchConfiguration"
import="com.amazonaws.services.ec2.AmazonEC2Client"
import="com.amazonaws.services.ec2.model.AvailabilityZone"
import="com.amazonaws.services.autoscaling.model.DescribeAutoScalingGroupsRequest"
import="com.amazonaws.services.autoscaling.model.AutoScalingGroup"
import="com.amazonaws.auth.BasicAWSCredentials"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Edit AutoScaling Group</title>
<!-- Bootstrap -->
<link href="css/bootstrap.css" rel="stylesheet" media="screen">
<style type="text/css">
body {
	padding-top: 20px;
	padding-bottom: 60px;
	font-size:95%;
}

.sidebar-nav {
	padding: 9px 0;
}
}
</style>
<script src="http://code.jquery.com/jquery.js"></script>
<script src="js/bootstrap.min.js"></script>
<script type="text/javascript">
  function check(){
    var zones = document.getElementsByName("zones");
    var count=0;
    for(var i=0;i<zones.length;i++){
      if(zones[i].checked)
        count++;

    }
    console.log("count: "+count);
    if(count == 0){
      alert("Choose at least one Availability Zone !");
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

  form = document.getElementById("form");
  form.action="CreateAutoScaling";
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
AmazonEC2Client ec2Client = new AmazonEC2Client(basicAWSCredentials);
List<AvailabilityZone> zones= ec2Client.describeAvailabilityZones().getAvailabilityZones();
String groupname = (String)request.getParameterValues("checkbox1")[0];
DescribeAutoScalingGroupsRequest dsRequest = new DescribeAutoScalingGroupsRequest().withAutoScalingGroupNames(groupname);
AutoScalingGroup asg = client.describeAutoScalingGroups(dsRequest).getAutoScalingGroups().get(0);
%>
<form id ="form" action="CreateAutoScaling" method="post">
<input type="hidden" name="msg" value="update"/>
<h2 align="center">Edit AutoScaling Group</h2><br>
<div class="well" style="padding:40px ">
 <table align="center" cellpadding=3>
  			  <tr>
  			    <td align="right">Group name: *</td>
  			    <td><input type="text" disabled value=<%=groupname %>  >
            <input type="hidden" name="groupname" value=<%=groupname %> >
            </td>
  			  </tr>
  			  <tr>
  			    <td align="right">Launch Configuration: *</td>
  			    <td><select name="launchconfig">
  			        <%for(LaunchConfiguration lc: configs) { 
  			        	if(lc.getLaunchConfigurationName().equals(asg.getLaunchConfigurationName())){
  			        %>
    	            <option selected><%=lc.getLaunchConfigurationName() %></option>
    	            <%} else{%>
    	            <option><%=lc.getLaunchConfigurationName() %></option>
    	           <%} }%>
    	           </select>
    	        </td>
  			  </tr>
  			  <tr>
  			    <td align="right">Availability Zone: *</td>
  			    <td>  
  			    <%for(AvailabilityZone az:zones) {
  			    	boolean checked = false;
  			    	for(String existingzone:asg.getAvailabilityZones()){
  			    		if(existingzone.equals(az.getZoneName())){
  			    			checked = true;
  			    			break;
  			    		}
  			    	}
  			    	if(checked){
  			    %>
  			      <input type="checkbox" name="zones" value=<%=az.getZoneName() %> checked>&nbsp;<%=az.getZoneName() %><br>
  			    <%}else{ %>
  			    <input type="checkbox" name="zones" value=<%=az.getZoneName() %> >&nbsp;<%=az.getZoneName() %><br>
  			    <%} } %>
  			    </td>
  			  </tr>
  			  <tr>
  			    <td align="right">Instance number:</td>
  			    <td>Max*:&nbsp;<input type="text" style="width:40px;margin-right:5px" id='max' name="maxsize" value=<%=asg.getMaxSize() %>>
  			        Min*:&nbsp;<input type="text" style="width:40px;margin-right:5px" id='min' name="minsize" value=<%=asg.getMinSize() %>>
  			        Desired:&nbsp;<input type="text" style="width:40px;margin-right:5px" id='desired' value=<%=asg.getDesiredCapacity() %> name="capacity">
  			    </td>
  			  </tr>
  			  <tr>
  			    <td align="right">Health Check Type:</td>
  			    <td>
  			     <%if(asg.getHealthCheckType().equals("EC2")) { %>
  			      <input type="radio" name="healthchecktype" value="EC2" checked>
  			     <%} else{ %>
  			      <input type="radio" name="healthchecktype" value="EC2" > 
  			      <%} %>
  			      &nbsp;Amazon EC2&nbsp;&nbsp;
  			       <%if(asg.getHealthCheckType().equals("ELB")) { %>
  			      <input type="radio" name="healthchecktype" value="ELB" checked>
  			     <%} else{ %>
  			      <input type="radio" name="healthchecktype" value="ELB" > 
  			      <%} %>
  			      &nbsp;Elastic Load Balancer
  			    </td>
  			  </tr>
  			  <tr>
  			    <td align="right"> Health Check Grace Period: </td>
  			    <td><input type="text" name="graceperiod" style="width:60px;margin-right:10px" value=<%=asg.getHealthCheckGracePeriod() %>>seconds</td>
  			  </tr>
  			  <tr>
  			    <td align="right">Default Cool Down(s): </td>
  			    <td><input type="text" name="cooldown" style="width:60px;margin-right:10px"  value=<%=asg.getDefaultCooldown() %>> seconds</td>
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
  			<div style="text-align:center;margin-top:30px">
  			  <a href="autoscaling.jsp" class="btn">Cancel</a>&nbsp;&nbsp;
  			  <button class="btn btn-success" type="button" onclick="check()">Submit</button>
  			</div>
  	    </div>
   </form>
</body>
</html>