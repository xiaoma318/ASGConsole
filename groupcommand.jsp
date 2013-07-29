<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"
import = "com.amazonaws.auth.BasicAWSCredentials"   
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
<title>Enter Command To Group</title>
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
    var instances = document.getElementsByName("instances");
    if(instances==null){
      alert("no instances!");
      return;
    }
    var count =0;
    for(var i=0;i<instances.length;i++){
      if(instances[i].checked)
        count++;
    }
    if(count == 0){
       alert("no instances!");
      return;

    }
  form = document.getElementById("form");
  form.action="GroupCommand";
  form.submit();
  }
</script>
</head>
<body>
<%
BasicAWSCredentials basicAWSCredentials = (BasicAWSCredentials)session.getAttribute("AWSCredentials");
//BasicAWSCredentials basicAWSCredentials = new BasicAWSCredentials("AKIAJR3XOWMQKVZXHOYQ","1L7iMWoKktZx9ZqAjBQx8JajA9BDVwJtVSf6GX1T");
String groupname = (String)request.getAttribute("groupname");
if(groupname == null)
   groupname = (String)request.getParameterValues("checkbox1")[0];
//String groupname="my-group-1";
AmazonAutoScalingClient client = new AmazonAutoScalingClient(basicAWSCredentials);
DescribeAutoScalingGroupsRequest dsRequest = new DescribeAutoScalingGroupsRequest().withAutoScalingGroupNames(groupname);
AutoScalingGroup asg = client.describeAutoScalingGroups(dsRequest).getAutoScalingGroups().get(0);
List<Instance> instances = asg.getInstances();
String feedback = (String)request.getAttribute("res");
String filepath = (String)request.getAttribute("filepath");
%>

  <form id ='form' action="GroupCommand" method="post">
  <input type="hidden" name="groupname" value=<%=groupname %>>
    <h3 align="center">Enter Command To Instance</h3><br>
    <div class="well" style="padding:40px">
      <table align="center" cellpadding=3>
         <tr>
  		 	<td align="right"><b>Instances:</b></td>
  		 	
  			<td>
  			 <%for(Instance instance:instances){ %>
  			 <input type = "checkbox" name="instances" style="margin-left:10px" value=<%=instance.getInstanceId()%> checked><%=instance.getInstanceId() %>
  			 <%} %>
            </td>
  		 </tr>
     	 <tr>
  		 	<td align="right">User name: *</td>
  			<td><input style="width:150px" type="text" name="username" value="ec2-user" ></td>
  		 </tr>
  	
  		 <tr>
  			 <td align="right">Private Key path: *</td>
  			 <td><input style="width:350px" type="text" name="filepath" value=<%=filepath %>></td>
  		 </tr>
  		 <tr>
  		   <td align="right">Command: *</td>
  		   <td><textarea rows="5" cols="10" style="width:300px" name="cmd"></textarea>
  		 </tr>
  	   </table>
  			<div style="text-align:center;margin-top:30px">
  			  <a href="autoscaling.jsp" class="btn">Back</a>&nbsp;&nbsp;
  			  <button class="btn btn-success" type="button" onclick="check()">Execute</button>
  			</div>
  	    </div>
  	    <h4 align="center"> Return Information: </h4>
  	    <div style="text-align:center">
  	    <textarea rows="8" cols="" style="width:600px;font-family: Consolas, monaco, monospace;" ><%=feedback%></textarea>
  	    </div>
   </form>
</body>
</html>