<!---
	Name:			/tags/layout.cfm
	Last Updated:	06/02/05
	History:
--->

<cfparam name="attributes.title" default="">

<cfif thisTag.executionMode is "start">

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type"
content="text/html; charset=windows-1252" />
<meta name="author" content="J.Reiser" />
<title>#attributes.title#</title>
<link rel="stylesheet" type="text/css" href="stylesheets/layout.css" />
<link rel="stylesheet" type="text/css" href="stylesheets/color.css" />

</head>

<body>
<div id="perm-links">
<ul>
<li><a href="index.cfm">Home</a></li>
<li><a href="index.cfm?logout=1">Logout</a></li>
<!---<li><a href="mailto:ray@camdenfamily.com?subject=#urlEncodedFormat(application.title)#">Contact</a></li>--->
</ul>
</div>

<h1>#application.title#</h1>

</div>
<div id="main-menu">
<h3>Navigation</h3>
<ul>
<li><a href="clients.cfm">clients</a></li>
<li><a href="ads.cfm">ads</a></li>
<li><a href="campaigns.cfm">campaigns</a></li>
<li><a href="reports.cfm">reports</a></li>
<li><a href="users.cfm">users</a></li>
</ul>
</div>

<div id="content">
</cfoutput>

<cfelse>

<cfoutput>
</div>

<div id="footer">
<h5>Design from j.reiser at <a href="http://www.oswd.org/viewdesign.phtml?id=1927&referer=%2Fsearch.php%3Fsearchstring%3Dcore%2Belements%26tab%3Ddescription">OSWD</a> Copyleft for everyone's use, 7 Feb, 2005</h5>
</div>
</body>
</html>
</cfoutput>

</cfif>
