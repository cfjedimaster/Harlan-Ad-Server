<!---
	Name:			/clients.cfm
	Last Updated:	06/02/05
	History:
--->

<cfif isDefined("form.editclient") and isDefined("form.data.id")>
	<cflocation url="client_edit.cfm?id=#form.data.id#" addToken=false>
</cfif>
<cfif isDefined("form.addclient")>
	<cflocation url="client_edit.cfm?id=" addToken=false>
</cfif>


<cfif isDefined("url.deleteClient")>
	<cfset application.clientDAO.delete(url.deleteClient)>
	<cflocation url="clients.cfm" addToken="false">
</cfif>

<cfmodule template="tags/layout.cfm" title="#application.title# - Clients">

<cfset clients = application.clientManager.getClients()>

<cfoutput>
<h2>Clients</h2>
<p>
<cfif clients.recordCount>
<table class="mainTable">
	<tr>
		<th>Name</th>
		<th>Email Address</th>
		<td>&nbsp;</td>
	</tr>
	<cfloop query="clients">
		<tr valign="top">
			<td><a href="client_edit.cfm?id=#id#">#name#</a><cfif len(notes)><br/>#notes#</cfif></td>
			<td>#emailaddress#</td>
			<td><a href="clients.cfm?deleteClient=#id#">Delete</a></td>
		</tr>
	</cfloop>
</table>
<cfelse>
	There are no clients yet.
</cfif>
</p>

<p>
<a href="client_edit.cfm">New Client</a>
</p>

</cfoutput>

</cfmodule>
