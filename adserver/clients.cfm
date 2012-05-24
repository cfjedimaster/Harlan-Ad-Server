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
	<cflocation url="clients.cfm?msg=success:::delete successfully." addToken="false">
</cfif>

<cfmodule template="tags/layout.cfm" title="#application.title# - Clients">

<cfset clients = application.clientManager.getClients()>

<cfoutput>
<h2>Clients</h2>
<p class="row">
	<a href="client_edit.cfm" class="btn btn-success pull-right">
		<i class="icon-plus icon-white"></i>New Client
	</a>
</p>

<cfif clients.recordCount>
<table <!---class="mainTable"---> class="table table-striped table-bordered table-condensed tablesorter">
	<thead>
		<tr>
			<th>Name</th>
			<th>Email Address</th>
			<th class="nosort">&nbsp;</th>
		</tr>
	</thead>
	<tbody>
		
		<cfloop query="clients">
			<tr valign="top">
				<td><a href="client_edit.cfm?id=#id#">#name#</a><cfif len(notes)><br/>#notes#</cfif></td>
				<td>#emailaddress#</td>
				<td width="100px"><a href="client_edit.cfm?id=#id#" class="icon-pencil" rel="tooltip" title="Edit client"></a> &nbsp; &nbsp;| &nbsp; &nbsp; 
				<a href="javascript:void(0);" onclick="javascript:confirmDelete('clients.cfm?deleteClient=#id#')" class="icon-trash" rel="tooltip" title="Delete client"></a></td>
			</tr>
		</cfloop>
	</tbody>
</table>
<cfelse>
	<p class="alert alert-error">
		<i class="icon-white icon-warning-sign"></i><strong> There are no clients yet.</strong>
	</p>		
</cfif>

<!---<p>
<a href="client_edit.cfm">New Client</a>
</p>--->

</cfoutput>

</cfmodule>
