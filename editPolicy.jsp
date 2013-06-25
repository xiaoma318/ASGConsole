<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"
import = "java.util.List"
import=" com.amazonaws.services.autoscaling.model.Instance"
import=" com.amazonaws.auth.AWSCredentialsProvider"
import=" com.amazonaws.auth.ClasspathPropertiesFileCredentialsProvider"
import="com.amazonaws.services.autoscaling.AmazonAutoScalingClient"
import=" com.amazonaws.services.autoscaling.model.LaunchConfiguration"
import="com.amazonaws.services.ec2.AmazonEC2Client"
import="com.amazonaws.services.ec2.model.AvailabilityZone"
import="com.amazonaws.services.autoscaling.model.DescribePoliciesRequest"
import="com.amazonaws.services.autoscaling.model.ScalingPolicy"
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
function showHint(){
	hint.innerHTML="This is just for PercentChangeInCapacity Adjustment Type";
}
function   moveto()  
{  
hint.innerHTML="   ";  
 
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
String str = (String)request.getParameterValues("checkbox")[0];
String policyname = str.substring(0, str.indexOf(";"));
DescribePoliciesRequest dpRequest = new DescribePoliciesRequest().withPolicyNames(policyname);
ScalingPolicy sp = client.describePolicies(dpRequest).getScalingPolicies().get(0);
List<AutoScalingGroup> groups = client.describeAutoScalingGroups().getAutoScalingGroups();
%>
<form action="PutScalingPolicy" method="post">
<input type="hidden" name="msg" value="update"/>
<h2 align="center">Edit Scaling Policy</h2><br>
<div class="well" style="padding:40px ">
 <table align="center" cellpadding=3>
  			  <tr>
  			    <td align="right">Policy Name: *</td>
  			    <td><input type="text" name="policyname" value=<%=policyname %> ></td>
  			  </tr>
  			  <tr>
  			    <td align="right">AutoScaling Group: *</td>
  			    <td><select name="groupname">
  			        <%for(AutoScalingGroup asg: groups) { 
  			        	if(asg.getAutoScalingGroupName().equals(sp.getAutoScalingGroupName())){
  			        %>
    	            <option selected><%=asg.getAutoScalingGroupName() %></option>
    	            <%} else{%>
    	            <option><%=asg.getAutoScalingGroupName() %></option>
    	           <%} }%>
    	           </select>
    	        </td>
  			  </tr>
  			  <tr>
  			    <td align="right">Adjustment: *</td>
  			    <td><input type="text" name="adjustment" value=<%=sp.getScalingAdjustment() %>></td>
  			  </tr>
  			  <tr>
  			    <td align="right">Adjustment Type: </td>
  			    <td>  
  			      <select name="adjustmenttype">
  			        <option><%=sp.getAdjustmentType() %></option>
    	            <option>ChangeInCapacity</option>
    	            <option>ExactCapacity</option>
    	            <option>PercentChangeInCapacity</option>
    	          </select>
  			    </td>
  			  </tr>
  			   <tr>
  			    <td align="right">Min Adjustment Step: </td>
  			    <td><input type="text" name="minadjustmentstep" id="minstep" ></td>
  			  </tr>
  			  <tr>
  			    <td align="right">Cool Down(s):</td>
  			    <td><input type="text" name="cooldown"></td>
  			  </tr>
  			</table>
  			<div style="text-align:center;margin-top:30px">
  			  <a href="scalingpolicy.jsp" class="btn">Cancel</a>&nbsp;&nbsp;
  			  <button class="btn btn-success" type="submit">Submit</button>
  			</div>
  	    </div>
   </form>
</body>
</html>