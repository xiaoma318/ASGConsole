<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"
import = "java.util.List"
import=" com.amazonaws.auth.AWSCredentialsProvider"
import=" com.amazonaws.auth.ClasspathPropertiesFileCredentialsProvider"
import="com.amazonaws.services.autoscaling.AmazonAutoScalingClient"
import=" com.amazonaws.services.autoscaling.model.LaunchConfiguration"
import="com.amazonaws.services.ec2.model.KeyPairInfo"
import="com.amazonaws.services.ec2.model.DescribeKeyPairsResult"
import="com.amazonaws.services.ec2.AmazonEC2Client"
import="com.amazonaws.services.ec2.model.SecurityGroup"
import="com.amazonaws.auth.BasicAWSCredentials"
import="java.io.*"
import="com.amazonaws.services.ec2.model.InstanceType"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Launch Configuration</title>
<!-- Bootstrap -->
<link href="css/bootstrap.css" rel="stylesheet" media="screen">
<style type="text/css">
body {
	padding-top: 60px;
	padding-bottom: 40px;
	
}
.scroll{

  height:400px;
  width:100%;
  
  overflow:auto;
}
.sidebar-nav {
	padding: 9px 0;
}

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
		form.action="CreateLC";
		break;
	case 2:
		form.action="DeleteLC";
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
AmazonEC2Client ec2Client = new AmazonEC2Client(basicAWSCredentials);
DescribeKeyPairsResult describeKeyPair =  ec2Client.describeKeyPairs();
List<KeyPairInfo> keypairs = describeKeyPair.getKeyPairs();
List<SecurityGroup> describeSC= ec2Client.describeSecurityGroups().getSecurityGroups();
%>	
<script type="text/javascript">
function checkLC(){
	var lcname = document.getElementById("lcname").value;
	if(lcname==""){
		alert("Name cannot be empty !");
		return;
	}
	<% for(LaunchConfiguration lc : configs){%>
	  var name = "<%=lc.getLaunchConfigurationName()%>";
	   if(lcname == name){
		   alert("Name existed, choose another name !");
		   return;
	   }
	<%}%>
	var ami = document.getElementById("ami").value;
	if(ami==""){
		alert("AMI cannot be empty !");
		return;
	}
	var spotPrice = document.getElementById("spotprice").value;
	if(isNaN(spotPrice)){
		alert("Spot Price must be a number !");
		return;
	}
	
	var form = document.getElementById("form");
	form.action="CreateLC";
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
				<li class="active"><a href="launchconfig.jsp" style="color:white">Launch Configurations</a></li>
				<li><a href="autoscaling.jsp" style="color:black">AutoScaling Groups</a></li>
				<li><a href="scalingpolicy.jsp" style="color:black">Scaling Policies</a></li>
			</ul>
		  </div>
		</div>
		
		
		<div class="span10">
		<form id="form" method="post">
		  <a href="#lconfig" role="button" class="btn" data-toggle="modal"><b>Create Launch Configuration</b></a>
		   <!-- model1 -->
		  <div id="lconfig" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-header">
   			  <h3 id="myModalLabel" align="center">Launch Configuration</h3>
  			</div>
  			<div class="modal-body">
  			<table cellpadding=3>
  			  <tr>
  			    <td width="150px" align="right">Name: *</td>
  			    <td><input type="text" name="lcname" id="lcname"></td>
  			  </tr>
  			 <tr>
  			    <td align="right">AMI: *</td>
  			    <td><input type="text" name="ami" id="ami" /></td>
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
  			    <td><select name="keypair">
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
  			    <td><input type="text" name="spotprice" id="spotprice"></td>
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
     		  <button class="btn btn-primary" type="button" onclick=" checkLC()">Create</button>
  			</div>
		  </div>
		
		   <!--  <button  class="btn" id="del" name="del" disabled><b>Delete</b></button>
		  -->
		  <button class="btn" onclick="formSubmit(2)" id="del" disabled><b>Delete Launch Configuration</b></button>
		  
	
		   <a style="margin-left: 10px" class="btn pull-right" href="#setting" data-toggle="modal"><i class="icon-cog"></i></a>
		     <!-- model2 -->
		  <div id="setting" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-header">
   			  <h4 id="myModalLabel" align="center">Show/Hide Columns</h4>
  			</div>
  			<div class="modal-body" style="margin-left:20px">
  			<h5>Launch Configuration Attributes:</h5>
  			<table cellpadding=10>
  			  <tr>
  			    <td width="120px"><input type="checkbox" name="setCheckbox" style="margin:5px" checked/>Name</td>
  			    <td width="150px"><input type="checkbox" name="setCheckbox" style="margin:5px" checked/>AMI</td>
  			    <td width="140px"><input type="checkbox" name="setCheckbox" style="margin:5px" checked/>Instance Type</td>
  			  </tr>
  			  <tr>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>Key Pair</td>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>Security Group</td>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>Monitoring</td>
  			  </tr>
  			  <tr>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>Spot Price</td>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>IAM Instance Profile</td>
  			    <td><input type="checkbox" name="setCheckbox"  style="margin:5px" checked/>EBS Optimized</td>
  			  </tr>
  			  <tr>
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
		  <!--  <input style="margin-bottom:10px" type="text" class="search-query" placeholder="Search"> -->
		  <br> <div class="scroll">
		   <table id="maintable" width="1200px" style="table-layout:fixed;word-break:break-all; word-wrap:break-all;" border=2 cellpadding=2>
		  
		     <tr style="font-weight:bold" height="30px" align="center">
		       <td width="30px"><input type="checkbox" onclick="selectAll('checkbox','del')"></td>
		       <td width="180px">Name</td>
		       <td width="120px">AMI</td>
		       <td width="110px">Instance Type</td>
		       <td width="100px">Key Pair</td>
		       <td width="150px">Security Group</td>
		       <td width="160px">Instance Monitoring</td>
		       <td width="80px">Spot Price</td>
		       <td width="160px">IAM Instance Profile</td>
		       <td width="120px">EBS Optimized</td>
		       <td width="220px">Created</td>
		     </tr>
		     <%for(LaunchConfiguration lc : configs){ %>
		     <tr align="center">
		     <td><input type="checkbox" name="checkbox" onclick="activeDel('checkbox','del')" value=<%=lc.getLaunchConfigurationName() %>></td>
		     <td><%=lc.getLaunchConfigurationName() %></td>
		     <td><%=lc.getImageId() %></td>
		     <td><%=lc.getInstanceType() %></td>
		     <td><%=lc.getKeyName() %></td>
		     <td><%for(String sg:lc.getSecurityGroups()){
		    	     out.print(sg+" ");
		           }
		    	 %>
		     </td>
		     <td><%=lc.getInstanceMonitoring() %></td>
		     <td><%=lc.getSpotPrice() %></td>
		     <td><%=lc.getIamInstanceProfile() %></td>
		     <td><%=lc.getEbsOptimized() %></td>
		     <td><%=lc.getCreatedTime() %></td>
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