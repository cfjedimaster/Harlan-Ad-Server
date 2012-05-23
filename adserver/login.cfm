<!---
	Name:			/login.cfm
	Last Updated:	08/16/06
	History:		focus on window load (rkc 8/16/06)
--->

<cfoutput>
<html>

<head>
<title>#application.title# Login</title>
<style>
BODY { background-color: white; }

.loginTable {
	border-style: solid;
	border-collapse: collapse;
	background-color: ##e0e0e0;
}

.loginTableHeader {
	background-color: black;
	color: white;
	font-family: Arial;
	font-weight: bold;
}

td {
	font-family: Arial;
}

input {
	width: 200px;
}

.button {
	width: 100px;
}
</style>
</head>

<body onload="document.getElementById('logonform').username.focus()">

<cfset qs = cgi.query_string>
<cfset qs = replaceNoCase(qs,"logout=1","")>

<form action="#cgi.script_name#?#qs#" method="post" id="logonform">
<table height="100%" width="100%">
	<tr>
		<td align="center" valign="middle">
		<table width="400" class="loginTable">
			<tr class="loginTableHeader">
				<td colspan="2">#application.title# Login</td>
			</tr>
			<tr>
				<td>username:</td>
				<td><input type="text" name="username"></td>
			</tr>
			<tr>
				<td>password:</td>
				<td><input type="password" name="password"></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><input type="submit" name="login" value="Login" class="button"></td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</form>

</body>
</html>
</cfoutput>