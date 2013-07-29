<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"
import = "java.util.List"
import=" com.amazonaws.services.autoscaling.model.AutoScalingGroup"
import=" com.amazonaws.services.autoscaling.model.Instance"
import=" com.amazonaws.auth.AWSCredentialsProvider"
import=" com.amazonaws.auth.ClasspathPropertiesFileCredentialsProvider"
import="com.amazonaws.services.autoscaling.AmazonAutoScalingClient"
import=" com.amazonaws.services.autoscaling.model.LaunchConfiguration"
import="com.amazonaws.services.autoscaling.model.ScalingPolicy"
import="com.amazonaws.services.ec2.model.KeyPairInfo"
import="com.amazonaws.services.ec2.model.DescribeKeyPairsResult"
import="com.amazonaws.services.ec2.AmazonEC2Client"
import="com.amazonaws.services.ec2.model.SecurityGroup"
import="com.amazonaws.services.ec2.model.AvailabilityZone"
import="com.amazonaws.services.ec2.model.InstanceType"
import="com.amazonaws.services.ec2.model.Image"
import="java.io.*"
import="com.amazonaws.auth.BasicAWSCredentials"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>NI AutoSclaing Console</title>
<!-- Bootstrap -->
<link href="css/bootstrap.css" rel="stylesheet" media="screen">
<style type="text/css">
body {
	padding-top: 60px;
	padding-bottom: 40px;
	font-family: Verdana, Geneva, sans-serif;
}

.sidebar-nav {
	padding: 9px 0;
}

</style>
<script src="http://code.jquery.com/jquery.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/helper.js"></script>
<script type="text/javascript">
function selectAMI(){
	var value = document.getElementById("allami");
	var e = document.getElementById("ami");
	e.value=value.value;
}

var secondsBeforeExpire = ${pageContext.session.maxInactiveInterval};
var timeToDecide = 30; // Give client 15 seconds to choose.
setTimeout(function() {
    alert('Your session is about to timeout in ' + timeToDecide + ' seconds!')
}, (secondsBeforeExpire - timeToDecide) * 1000);

</script>
</head>
<body>
<%
//AWSCredentialsProvider credentialsProvider = new ClasspathPropertiesFileCredentialsProvider();
BasicAWSCredentials basicAWSCredentials = (BasicAWSCredentials)session.getAttribute("AWSCredentials");
//BasicAWSCredentials basicAWSCredentials = new BasicAWSCredentials("AKIAJR3XOWMQKVZXHOYQ","1L7iMWoKktZx9ZqAjBQx8JajA9BDVwJtVSf6GX1T");
AmazonAutoScalingClient client = new AmazonAutoScalingClient(basicAWSCredentials);
List<LaunchConfiguration> configs = client.describeLaunchConfigurations().getLaunchConfigurations();
List<AutoScalingGroup> groups = client.describeAutoScalingGroups().getAutoScalingGroups();
List<ScalingPolicy> policies = client.describePolicies().getScalingPolicies();
AmazonEC2Client ec2Client = new AmazonEC2Client(basicAWSCredentials);
DescribeKeyPairsResult describeKeyPair =  ec2Client.describeKeyPairs();
List<KeyPairInfo> keypairs = describeKeyPair.getKeyPairs();
List<SecurityGroup> describeSC= ec2Client.describeSecurityGroups().getSecurityGroups();
List<AvailabilityZone> zones= ec2Client.describeAvailabilityZones().getAvailabilityZones();
//BufferedReader br = new BufferedReader(new FileReader("ami.txt"));
%>
<script type="text/javascript">
function checkLC(){
	var lcname = document.getElementById("lcname").value;
	if(lcname==""){
		alert("Name cannot be empty!");
		return;
	}
	<% for(LaunchConfiguration lc : configs){%>
	  var name = "<%=lc.getLaunchConfigurationName()%>";
	   if(lcname == name){
		   alert("Name existed, choose another name!");
		   return;
	   }
	<%}%>
	var ami = document.getElementById("ami").value;
	if(ami==""){
		alert("AMI cannot be empty!");
		return;
	}
	var spotPrice = document.getElementById("spotprice").value;
	if(isNaN(spotPrice)){
		alert("Spot Price must be a number!");
		return;
	}
	
	
	var form = document.getElementById("form1");
	form.submit();
}
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
		alert("Maxsize or Minsize or Desired should be number !");
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
	var form = document.getElementById("form2");
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
	var form = document.getElementById("form3");
	form.submit();
}
</script>
	<div class="navbar navbar-inverse navbar-fixed-top">
		<div class="navbar-inner">
			<div class="container-fluid">
				<a class="brand" href="#">AutoScaling</a>
			
				<ul class="nav">
					<li class="active"><a href="home.jsp">Home</a></li>
					<li><a href="#about" onclick="showAbout()">About</a></li>
					<li><a href="#contact" onclick="showContact()">Contact</a></li>
				</ul>
				<ul class="nav pull-right">
					<li><a href = "login.jsp" > Log out</a></li>
				</ul>

			</div>
		</div>
	</div>

   <div class="container-fluid">
	  <div class="row-fluid">
	   
		<div  class="span2">
		<div class="well" style="height:600px ">
			<ul class="nav nav-list">
				<li><h5>ASG Dashboard</h5></li>
			    <li class="divider"></li>
				<li><a href="launchconfig.jsp" style="color:black">Launch Configurations</a></li>
				<li><a href="autoscaling.jsp" style="color:black">AutoScaling Groups</a></li>
				<li><a href="scalingpolicy.jsp" style="color:black">Scaling Policies</a></li>
			</ul>
		</div>
	   </div>
		<div class="span10">
		  <h3>Resource</h3>
		  <hr style="margin-top:0px" color="#C0C0C0" size=1>
		  <h5>You are using the following Amazon AutoScaling resource:</h5>
		  <a href="launchconfig.jsp" ><font size=3><%=configs.size() %> Launch Configurations</font></a>
		  <br><a href="autoscaling.jsp"><font size=3><%=groups.size() %> AutoScaling Groups</font></a>
		  <br><a href="scalingpolicy.jsp"><font size=3><%=policies.size() %> Scaling Policies</font></a>
		  <br><br><br><br>
		  <h3>Create</h3>
		  <hr style="margin-top:0px" color="#C0C0C0" size=1>
		  
		  <table cellpadding=5>
		  <tr><td>
		  <form id="form1" action="CreateLC" method="post">
		  
		  <a href="#lconfig" role="button" class="btn btn-primary" data-toggle="modal">Launch Configuration</a>
		  <!-- model1 -->
		  <div id="lconfig" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-header">
   			  <h3 id="myModalLabel" align="center">Launch Configuration</h3>
  			</div>
  			<div class="modal-body">
  			<table cellpadding=3>
  			  <tr>
  			    <td width="150px" align="right">Name: *</td>
  			    <td><input type="text" name="lcname" id="lcname" > 
  			  </tr>
  			  <tr>
  			    <td align="right">AMI: *</td>
  			    <td><input type="text" name="ami" id="ami"/></td>
  			  </tr>
  			  <tr>
  			    <td align="right" width="120px">Instance Type: *</td>
  			    <td>  
  			      <select name="instancetype">
    	            <%for(InstanceType type:InstanceType.values()) {%>
    	            <option> <%=type %></option>
    	            <%} %>
    	           </select>
  			    </td>
  			  </tr>
  			  <tr>
  			    <td align="right">Key pair: </td>
  			    <td ><select name="keypair">
  			         <option>none</option>
  			    <%for(KeyPairInfo key: keypairs){ %>
  			         <option><%=key.getKeyName() %></option>
  			    <%} %>
  			      </select> 
  			    </td>
  			  </tr>
  			  <tr>
  			    <td align="right">Security Groups:</td>
  			    <td><%for(SecurityGroup sc: describeSC){ 
  			    	     if(sc.getVpcId()==null){
  			    %><input style="margin:5px" type="checkbox" name="securitygroup" value=<%=sc.getGroupName() %> ><%=sc.getGroupName() %>&nbsp;
  			    <%}}%>
  			    </td>
  			  </tr>
  			  <tr>
  			    <td align="right">Spot Price: </td>
  			    <td><input type="text" id="spotprice" name="spotprice"></td>
  			  </tr>
  			    <tr>
  			    <td align="right">Instance Monitoring: </td>
  			    <td>
  			      <input type="radio" name = "monitoring" value="true" checked> True
  			      <input type="radio" name = "monitoring"value="false" > False
  			    </td>
  			  </tr>
  			  <tr>
  			    <td align="right">IAM Instance Profile: </td>
  			    <td><input type="text" name="iam" id="iam"></td>
  			  </tr>
  			   <tr>
  			    <td align="right">EBS Optimized: </td>
  			    <td> <input type="radio" name = "ebs" value="true"> True
  			         <input type="radio" name = "ebs" value="false" checked> False
  			    </td>
  			  </tr>
  			</table>
  			</div>
 		    <div class="modal-footer">
  		      <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
     		  <button class="btn btn-primary"   type="button" onclick=" return checkLC()">Create</button>
  			</div>
		  </div>
		  </form>
		  </td>
		  
		 <td><form id="form2" action="CreateAutoScaling" method="post">
	     <a href="#autoscaling" role="button" class="btn btn-primary" data-toggle="modal">AutoScaling Group</a>
	     
	      <!-- model2 -->
		  <div id="autoscaling" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel2" aria-hidden="true">
			<div class="modal-header">
   			  <h3 id="myModalLabel2" align="center">Auto Scaling</h3>
  			</div>
  			<div class="modal-body">
  		 <table cellpadding=5>
  			  <tr>
  			    <td align="right">Group name: *</td>
  			    <td><input type="text" id="groupname" name="groupname" ></td>
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
  			      <input type="checkbox" name="zones" id="zones" value=<%=az.getZoneName() %>>&nbsp;<%=az.getZoneName() %><br>
  			    <%} %>
  			    </td>
  			  </tr>
  			  <tr>
  			    <td align="right">Instance number:</td>
  			    <td>Max*:&nbsp;<input type="text" id="max" style="width:40px;margin-right:5px" name="maxsize">
  			        Min*:&nbsp;<input type="text" id="min" style="width:40px;margin-right:5px" name="minsize">
  			        Desired:&nbsp;<input type="text" id="desired" style="width:40px;margin-right:5px" name="capacity">
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
  			    <td><input type="text" id="graceperiod" name="graceperiod" style="width:60px;margin-right:10px" value="600">seconds</td>
  			  </tr>
  			 <tr>
  			    <td align="right">Default Cool Down: </td>
  			    <td><input type="text" id="cooldown" name="cooldown" style="width:60px;margin-right:10px" value="300">seconds</td>
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
		  </div></form>
		  </td>
		  
		  <td><form id="form3" action="PutScalingPolicy" method="post">
		  <a href="#scalingpolicy" role="button" class="btn btn-primary" data-toggle="modal">Scaling Policy</a>
		  <!-- model3 -->
		  
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
  			    <td>
  			      <select name="groupname">
  			        <%for(AutoScalingGroup group: groups){ %>
  			        <option><%=group.getAutoScalingGroupName() %></option>
  			        <%}%>
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
  			      <select name="adjustmenttype"  id="adjustmenttype" onclick="checkAdjustment()">
    	            <option onclick="disable()">ChangeInCapacity</option>
    	            <option onclick="disable()">ExactCapacity</option>
    	            <option onclick="active()">PercentChangeInCapacity</option>
    	          </select>
  			    </td>
  			  </tr>
  			   <tr>
  			    <td align="right">Min Adjustment Step: </td>
  			    <td><input type="text" name="adjustmentstep" id="minstep" disabled></td>
  			  </tr>
  			  <tr>
  			    <td align="right">Cool Down(s):</td>
  			    <td><input type="text" name="cooldown"></td>
  			  </tr>
  			  
  			</table>
  			</div>
 		    <div class="modal-footer">
  		      <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
     		  <button class="btn btn-primary" type="button" onclick="checkSC()">Create</button>
  			</div>
		  </div></form>
		  </td></tr>
		  </table>
		  
	 	</div>  
	 	
      </div>
    </div>
	
</body>
</html>