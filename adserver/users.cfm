<!---
	Name:			/users.cfm
	Last Updated:	06/02/05
	History:
--->


<cfif isDefined("url.deleteUser")>
	<cfset application.userDAO.delete(url.deleteUser)>
	<cflocation url="users.cfm?msg=success:::User deleted successfully." addToken="false">
</cfif>

<cfmodule template="tags/layout.cfm" title="#application.title# - Users">

<cfset users = application.userManager.getUsers()>

<cfoutput>
<h2>Users</h2>
<p class="row">
	<a href="user_edit.cfm" class="btn btn-success pull-right">
		<i class="icon-plus icon-white"> </i>New User
	</a>
</p>
<cfif users.recordCount>
	<table class="table table-striped table-bordered table-condensed tablesorter">
		<thead>
			<tr>
				<th>Username</th>
				<th>Name</th>
				<th>Email Address</th>
				<th class="nosort">&nbsp;</th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="users">
				<tr valign="top">
					<td><a href="user_edit.cfm?id=#id#">#username#</a></td>
					<td>#name#</td>
					<td>#emailaddress#</td>
					<td width="100px">
						<a href="user_edit.cfm?id=#id#" class="icon-pencil"  rel="tooltip" title="Edit user"></a> &nbsp; &nbsp;| &nbsp; &nbsp;
						<a class="icon-trash"  rel="tooltip" title="Delete user" href="javascript:void(0);" onclick="javascript:confirmDelete('users.cfm?deleteUser=#id#')"></a>
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
<cfelse>
	<p class="alert alert-error">
		<i class="icon-white icon-warning-sign"></i><strong> There are no users defined yet.</strong>
	</p>
</cfif>
</cfoutput>

</cfmodule>
