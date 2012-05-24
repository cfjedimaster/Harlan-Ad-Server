<!---
	Name:			/user_edit.cfm
	Last Updated:	06/02/05
	History:
--->

<cfparam name="url.id" default="">

<cfif isDefined("form.return")>
	<cflocation url="users.cfm" addToken="false">
</cfif>

<cfif isDefined("form.save")>
	<cftry>
		<cfif url.id eq "">
			<cfset uBean = createObject("component","components.UserBean")>
			<cfset uBean.setName(form.name)>
			<cfset uBean.setEmailAddress(form.emailaddress)>
			<cfset uBean.setUsername(form.username)>
			<cfset uBean.setPassword(form.password)>
				
			<cfset errors = uBean.validate()>
			<cfif arrayLen(errors) is 0>
				<cfset uBean = application.userDAO.create(uBean)>
				<cfset application.userManager.setGroupsForUser(uBean.getID(),form.groups)>
				<cflocation url="users.cfm?msg=success:::User details added successfully." addToken="false">
			<cfelse>
				<cfset errormsg = arrayToList(errors,"<br>")>
			</cfif>
		<cfelse>
			<cfset uBean = application.userDAO.read(url.id)>
			<cfif uBean.getID() neq url.id>
				<cflocation url="users.cfm?msg=error:::Invaild user account." addToken="false">
			</cfif>
			<cfset uBean.setName(form.name)>
			<cfset uBean.setEmailAddress(form.emailaddress)>
			<cfset uBean.setUsername(form.username)>
			<cfset uBean.setPassword(form.password)>

			<cfset errors = uBean.validate()>
			<cfif arrayLen(errors) is 0>
				<cfset uBean = application.userDAO.update(uBean)>
				<cfset application.userManager.setGroupsForUser(uBean.getID(),form.groups)>
				<cflocation url="users.cfm?msg=success:::User details updated successfully." addToken="false">
			<cfelse>
				<cfset errormsg = arrayToList(errors,"<br>")>
			</cfif>
		</cfif>
		<cfcatch>
			<cfset errormsg = cfcatch.message & cfcatch.detail>
		</cfcatch>
	</cftry>
</cfif>

<cfif url.id neq "">
	<cfset u = application.userDAO.read(url.id)>
	<cfif url.id neq u.getID()>
		<cflocation url="users.cfm?msg=error:::Invaild user account." addToken="false">
	</cfif>
	<cfparam name="form.username" default="#u.getUsername()#">
	<cfparam name="form.name" default="#u.getName()#">
	<cfparam name="form.password" default="#u.getPassword()#">
	<cfparam name="form.emailaddress" default="#u.getEmailAddress()#">
<cfelse>
	<cfparam name="form.username" default="">
	<cfparam name="form.name" default="">
	<cfparam name="form.password" default="">
	<cfparam name="form.emailaddress" default="">
</cfif>

<cfmodule template="tags/layout.cfm" title="#application.title# - User Edit">

<cfset groups = application.usermanager.getGroups()>
<cfif url.id is not "">
	<cfset mygroups = application.usermanager.getGroupsForUser(url.id)>
<cfelse>
	<cfset mygroups = "">
</cfif>

<cfoutput>
<h2>User Edit</h2>
<cfif isDefined("errormsg")>
<div class="alert alert-error"><b>#errormsg#</b></div>
</cfif>
<p>

<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="main" id="main">

<p>
<fieldset title="User Information">
<legend>User Information</legend>
<table>
	<tr>
		<td><label for="username">Username:</label></td>
		<td><input type="text" id="username" name="username" value="#form.username#" class="required alphanumeric"></td>
	</tr>	
	<tr>
		<td><label for="name">Name:</label></td>
		<td><input type="text" id="name" name="name" value="#form.name#" class="required"></td>
	</tr>	
	<tr>
		<td><label for="email">Email Address:</label></td>
		<td><input type="text" id="email" name="emailaddress" value="#form.emailaddress#" class="required email"></td>
	</tr>	
	<tr>
		<td><label for="password">Password:</label></td>
		<td><input type="text" id="password" name="password" value="#form.password#" class="required"></td>
	</tr>	
</table>
</fieldset>
</p>

<p>
<fieldset title="Groups">
<legend>Groups</legend>
<p>
Note: In version 1 of this application, there is no real point in having a user who is <b>not</b>
a member of the admin group.
</p>
<table>
	<tr>
		<td><label for="groups">Groups:</label></td>
		<td>
		<select name="groups" id="groups">
		<cfloop query="groups">
		<option value="#id#" <cfif listFind(mygroups,id)>selected</cfif>>#name#</option>
		</cfloop>
		</select>
		</td>
	</tr>	
</table>
</fieldset>
</p>
<div class="form-actions">
<p>
<input type="submit" class="btn" name="return" value="Return to Users">
<input type="submit" class="btn btn-primary" name="save" value="Save">
</p>
</div>
</form>

</cfoutput>

</cfmodule>
