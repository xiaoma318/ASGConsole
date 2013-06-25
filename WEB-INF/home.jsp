<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
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
	font-size:95%;
}

.sidebar-nav {
	padding: 9px 0;
}

@media ( max-width : 980px) {
	/* Enable use of floated navbar text */
	.navbar-text.pull-right {
		float: none;
		padding-left: 3px;
		padding-right: 3px;
	}
}
}
</style>
</head>
<body>
	<script src="http://code.jquery.com/jquery.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<div class="navbar navbar-inverse navbar-fixed-top">
		<div class="navbar-inner">
			<div class="container-fluid">
				<a class="brand" href="#">AutoScaling</a>
				<p class="navbar-text pull-right">
					Logged in as <a href="#" class="navbar-link">Username</a>
				</p>
				<ul class="nav">
					<li class="active"><a href="#">Home</a></li>
					<li><a href="#about">About</a></li>
					<li><a href="#contact">Contact</a></li>
				</ul>
			</div>
		</div>
	</div>

	

		<div class="span3">
			<ul class="nav nav-list">
				<li>
					<h5>ASG Dashboard</h5>
				</li>
				<li><a href="#">Launch Configurations</a></li>
				<li><a href="#">Auto Scaling Groups</a></li>
				<li><a href="#">Scaling Policies</a></li>
			</ul>
		</div>
		<!--/span-->
		<div class="span1">
			<hr color="#C0C0C0" size=800 width=2>
		</div>
		<div class="span10">
			<h3>Resource</h3>
			<hr color="#C0C0C0" size=2>
			<h5>You are using the following Amazon AutoScaling resource:</h5>
			5 Launch Configurations
			<br>2 Auto Scaling Groups
			<br>1 Scaling Policies
			<br><br><br><br>
			<h3>Create</h3>
			<hr color="#C0C0C0" size=2>
			&nbsp;&nbsp;<a class="btn btn-primary" href="#">Launch Configuration</a>&nbsp;&nbsp;&nbsp;
			<a class="btn btn-primary" href="#">Auto Scaling Group</a>&nbsp;&nbsp;&nbsp;
			<a class="btn btn-primary" href="#">Scaling Policy</a>
		</div>

	
</body>
</html>