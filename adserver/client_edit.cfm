<!---
	Name:			/client_edit.cfm
	Last Updated:	06/02/05
	History:
--->

<cfif isDefined("form.return")>
	<cflocation url="clients.cfm" addToken="false">
</cfif>
<cfparam name="url.id" default="">

<cfif isDefined("form.save")>
	<cftry>
		<cfif url.id eq "">
			<cfset cBean = createObject("component","components.ClientBean")>
			<cfset cBean.setName(form.name)>
			<cfset cBean.setEmailAddress(form.emailaddress)>
			<cfset cBean.setNotes(form.notes)>			
			<cfset errors = cBean.validate()>
			<cfif arrayLen(errors) is 0>
				<cfset cBean = application.clientDAO.create(cBean)>
				<cflocation url="clients.cfm?msg=success:::Client details added successfully." addToken="false">
			<cfelse>
				<cfset errormsg = arrayToList(errors,"<br>")>
			</cfif>
		<cfelse>
			<cfset cBean = application.clientDAO.read(url.id)>
			<cfif cBean.getID() neq url.id>
				<cflocation url="clients.cfm?msg=error:::Invaild client account." addToken="false">
			</cfif>
			<cfset cBean.setName(form.name)>
			<cfset cBean.setEmailAddress(form.emailaddress)>
			<cfset cBean.setNotes(form.notes)>
			<cfset errors = cBean.validate()>
			<cfif arrayLen(errors) is 0>
				<cfset cBean = application.clientDAO.update(cBean)>
				<cflocation url="clients.cfm?msg=success:::Client details updated successfully." addToken="false">
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
	<cfset c = application.clientDAO.read(url.id)>
	<cfif url.id neq c.getID()>
		<cflocation url="clients.cfm?msg=error:::Invaild user account." addToken="false">
	</cfif>
	<cfparam name="form.name" default="#c.getName()#">
	<cfparam name="form.emailaddress" default="#c.getEmailAddress()#">
	<cfparam name="form.notes" default="#c.getNotes()#">
<cfelse>
	<cfparam name="form.name" default="">
	<cfparam name="form.emailaddress" default="">
	<cfparam name="form.notes" default="">
</cfif>

<cfmodule template="tags/layout.cfm" title="#application.title# - Client Edit">

<cfoutput>
<h2>Client Edit</h2>
<cfif isDefined("errormsg")>
<div class="alert alert-error"><b>#errormsg#</b></div>
</cfif>
<p>

<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="main" id="main">

<p>
<fieldset title="Client Information">
<legend>Client Information</legend>
<table>
	<tr>
		<td><label for="name">Name:</label></td>
		<td><input type="text" id="name" name="name" value="#form.name#" class="required"></td>
	</tr>	
	<tr>
		<td><label for="email">Email Address:</label></td>
		<td><input type="text" id="email" name="emailaddress" value="#form.emailaddress#" class="required email"></td>
	</tr>	
	<tr>
		<td colspan="2">
		<label for="notes">Notes:</label><br>
		<textarea name="notes" cols="50" rows="5">#form.notes#</textarea>
		</td>
	</tr>
</table>
</fieldset>
</p>
<div class="form-actions">
<p>
<input type="submit" class="btn" name="return" value="Return to Clients">
<input type="submit" class="btn btn-primary" name="save" value="Save">
</form>
</p>
</div>
</cfoutput>

</cfmodule>
