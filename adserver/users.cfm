<!---
	Name:			/users.cfm
	Last Updated:	06/02/05
	History:
--->


<cfif isDefined("url.deleteUser")>
	<cfset application.userDAO.delete(url.deleteUser)>
	<cflocation url="users.cfm" addToken="false">
</cfif>

<cfmodule template="tags/layout.cfm" title="#application.title# - Users">

<cfset users = application.userManager.getUsers()>

<cfoutput>
<h2>Users</h2>

<cfif users.recordCount>
	<table class="mainTable">
		<tr>
			<th>Username</th>
			<th>Name</th>
			<th>Email Address</th>
			<td>&nbsp;</td>
		</tr>
		<cfloop query="users">
			<tr valign="top">
				<td><a href="user_edit.cfm?id=#id#">#username#</a></td>
				<td>#name#</td>
				<td>#emailaddress#</td>
				<td><a href="users.cfm?deleteUser=#id#">Delete</a></td>
			</tr>
		</cfloop>
	</table>
<cfelse>
	<p>
		There are no users defined yet.
	</p>
</cfif>

<p>
	<a href="user_edit.cfm">New User</a>
</p>
</cfoutput>

</cfmodule>
