<!---
	Name:			/login.cfm
	Last Updated:	08/16/06
	History:		focus on window load (rkc 8/16/06)
--->

<cfoutput>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<!--[if lt IE 9]>
		<script src="http://html5shim.googlecode.com/svn/trunk/html5.js">

		</script>
		<![endif]-->
		
<link href="assets/css/bootstrap2.0.1.min.css" rel="stylesheet">
<link href="assets/css/bootstrap-responsive2.0.1.min.css" rel="stylesheet">

<title>#application.title# Login</title>
<style>
BODY { background-color: white;
	    padding-bottom: 40px;
	    padding-top: 60px;
	}
legend{margin-bottom:10px}
.form-horizontal .controls {
    margin-left: 100px;
}
.form-horizontal .control-group > label {width:80px}
</style>
</head>

<body onload="document.getElementById('logonform').username.focus()">

<cfset qs = cgi.query_string>
<cfset qs = replaceNoCase(qs,"logout=1","")>


<div class="navbar navbar-fixed-top"> 
	<div class="navbar-inner">
		<div class="container">
			<a class="brand" href="index.cfm">#application.title#</a>
		</div> <!--- container --->
	</div>
</div>
<div class="container">	

<form action="#cgi.script_name#?#qs#" method="post" id="logonform" class="form-horizontal">
<table height="100%" width="100%">
	<tr>
		<td align="center" valign="middle">
		<table width="400" class="table-bordered  well">
			<tr>
				<td>
			    <fieldset>
				    <legend>Login</legend>
					
					<cfif isDefined("loginError")>
						<div class="alert alert-error">
							<b>#loginError#</b>
						</div>
					</cfif>	
				    <div class="control-group">
				    	<label class="control-label" for="input01">username:</label>
				    	<div class="controls">
				    		<input type="text" name="username">
					    </div>
				    </div>
					<div class="control-group">
				    	<label class="control-label" for="input01">password:</label>
				    	<div class="controls">
				    		<input type="password" name="password">
					    </div>
				    </div>
					<div class="control-group">
						<div class="controls">
				            <button class="btn btn-primary" type="submit" name="login" value="Login">Login</button>
						</div>
				    </div>
			    </fieldset>
    
				</td>
			</tr>	
		</table>
		</td>
	</tr>
</table>
</form>
</div>
</body>
</html>
</cfoutput>