<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href="css/bootstrap.css" rel="stylesheet" media="screen">
<style type="text/css">
     body {
        padding-top: 80px;
        padding-bottom: 40px;
        background-color: #f5f5f5;
        font-family: 'Open Sans',sans-serif;
      }

      .form-signin {
        max-width: 400px;
        padding: 19px 29px 29px;
        margin: 0 auto 20px;
        background-color: #fff;
        border: 1px solid #e5e5e5;
        -webkit-border-radius: 5px;
           -moz-border-radius: 5px;
                border-radius: 5px;
        -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
           -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                box-shadow: 0 1px 2px rgba(0,0,0,.05);
      }
      .form-signin .form-signin-heading,
      .form-signin .checkbox {
        margin-bottom: 10px;
      }
      .form-signin input[type="text"],
      .form-signin input[type="text"] {
        font-size: 16px;
        height: auto;
        margin-bottom: 15px;
        padding: 7px 9px;
      }
      img{
        display: inline;
      }
     

    </style>
<title>NI AutoScaling --- Login in</title>
</head>
<script type="text/javascript">
function check(){
	var accesskey = document.getElementById("accesskey").value;
	var secretkey = document.getElementById("secretkey").value;
	if(accesskey == "" || secretkey == ""){
		alert("Access Key or Secret Key cannot be empty !");
		return;
	}
	
	var form = document.getElementById("form");
	form.submit();
}
</script>
<body>
<%
String msg = (String)request.getAttribute("msg");
if(msg!=null)
	 out.println("<script>alert('Access key or Secret key not correct!')</script>");
%>
 <div class="container">

     <form id="form" action="LoginIn" method="post" class="form-signin">
        <h2 class="form-signin-heading" ><img style="width:50px;height:50px;margin-left:30px;margin-right:10px" src='img/cloud.png'>NI AutoScaling</h2>
       <b>Access Key:</b> <input type="text" id="accesskey" name="accesskey" class="input-block-level" >
       <b>Secret Key:</b> <input type="text" id="secretkey" name="secretkey" class="input-block-level" >
      
        <button class="btn btn-large btn-primary" type="button" onclick="check()">Sign in</button>
      </form>

    </div> <!-- /container -->
</body>
</html>