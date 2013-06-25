<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"
import = "com.amazonaws.auth.BasicAWSCredentials"    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Enter Command To Instance</title>
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
</head>
<body>
<%String feedback = (String)request.getAttribute("feedback");%>
<%String instance = request.getParameter("instance");
if (instance == null){
	instance = (String)request.getAttribute("instance");
}
%>
  <form action="Command" method="post">
    <input type="hidden" name="dns" value=<%=request.getParameter("dns") %> >
    <input type="hidden" name="instance" value=<%=instance%> >
    <h3 align="center">Enter Command To Instance</h3><br>
    <div class="well" style="padding:40px">
      <table align="center" cellpadding=3>
         <tr>
  		 	<td align="right"><b>Instance:</b></td>
  			<td><%=instance %></td>
  		 </tr>
     	 <tr>
  		 	<td align="right">User name: *</td>
  			<td><input style="width:150px" type="text" name="username" value="ec2-user" ></td>
  		 </tr>
  	
  		 <tr>
  			 <td align="right">Private Key path: *</td>
  			 <td><input style="width:350px" type="text" name="filepath" ></td>
  		 </tr>
  		 <tr>
  		   <td align="right">Command: *</td>
  		   <td><textarea rows="5" cols="10" style="width:300px" name="cmd"></textarea>
  		 </tr>
  	   </table>
  			<div style="text-align:center;margin-top:30px">
  			  <a href="autoscaling.jsp" class="btn">Back</a>&nbsp;&nbsp;
  			  <button class="btn btn-success" type="submit">Execute</button>
  			</div>
  	    </div>
  	    <h4 align="center"> Return Information: </h4>
  	    <div style="text-align:center">
  	    <textarea rows="5" cols="" style="width:400px" ><%=feedback%></textarea>
  	    </div>
   </form>
</body>
</html>