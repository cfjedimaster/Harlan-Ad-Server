<!---
	Name:			/campaigns.cfm
	Last Updated:	5/28/07
	History:		Support for resetting ads
--->


<cfif isDefined("url.deletecampaign")>
	<cfset application.campaignDAO.delete(url.deletecampaign)>
	<cflocation url="campaigns.cfm?msg=success:::delete successfully." addToken="false">
</cfif>

<cfif isDefined("url.resetstats")>
	<cfset application.campaignManager.resetStats(url.resetstats)>
	<cflocation url="campaigns.cfm" addToken="false">
</cfif>

<cfmodule template="tags/layout.cfm" title="#application.title# - Campaigns">

<cfset campaigns = application.campaignManager.getCampaigns()>

<cfset queryAddColumn(campaigns,"code",arrayNew(1))>

<cfloop query="campaigns">
	<cfset querySetCell(campaigns,"code",trim(application.utils.getLinkCode(campaignid=id)),currentRow)>
</cfloop>

<cfoutput>
<h2>Campaigns</h2>
<p class="row">
	<a href="campaign_edit.cfm"" class="btn btn-success pull-right">
		<i class="icon-plus icon-white">
		</i>
		New Campaign
	</a>
</p>
<cfif campaigns.recordCount>
	<table <!---class="mainTable"---> class="table table-striped table-bordered table-condensed tablesorter">
		<thead>
			<tr>
				<th>Name</th>
				<th>Impressions</th>
				<th>Clicks</th>
				<th>Active</th>
				<th>Updated</th>
				<th class="nosort">&nbsp;</th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="campaigns">
				<tr valign="top">
					<td><a href="campaign_edit.cfm?id=#id#">#name#</a></td>
					<td>#numberFormat(impressions)#</td>
					<td>#numberFormat(clicks)#</td>
					<td>#yesNoFormat(active)#</td>
					<td>#dateFormat(updated,"short")# #timeFormat(updated,"short")#</td>
					<td width="150px">
						<a href="campaign_edit.cfm?id=#id#"  rel="tooltip" title="Edit campaign" class="icon-pencil"></a> &nbsp; &nbsp;| &nbsp; &nbsp;
						<a class="icon-trash"  rel="tooltip" title="Delete campaign" href="javascript:void(0);" onclick="javascript:confirmDelete('campaigns.cfm?deleteCampaign=#id#')"></a> &nbsp; &nbsp;| &nbsp; &nbsp; 
						<a href="campaigns.cfm?resetStats=#id#" class="icon-refresh"  rel="tooltip" title="Reset campaign"></a>
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
<cfelse>
	<p class="alert alert-error">
		<i class="icon-white icon-warning-sign"></i><strong> There are no campaigns defined yet.</strong>
	</p>
</cfif>

<!---<p>
<a href="campaign_edit.cfm">New Campaign</a>
</p>--->

</cfoutput>


</cfmodule>
