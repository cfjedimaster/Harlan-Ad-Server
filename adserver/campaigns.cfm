<!---
	Name:			/campaigns.cfm
	Last Updated:	5/28/07
	History:		Support for resetting ads
--->


<cfif isDefined("url.deletecampaign")>
	<cfset application.campaignDAO.delete(url.deletecampaign)>
	<cflocation url="campaigns.cfm" addToken="false">
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

<cfif campaigns.recordCount>
	<table class="mainTable">
		<tr>
			<th>Name</th>
			<th>Impressions</th>
			<th>Clicks</th>
			<th>Active</th>
			<th>Updated</th>
			<td>&nbsp;</td>
		</tr>
		<cfloop query="campaigns">
			<tr valign="top">
				<td><a href="campaign_edit.cfm?id=#id#">#name#</a></td>
				<td>#numberFormat(impressions)#</td>
				<td>#numberFormat(clicks)#</td>
				<td>#yesNoFormat(active)#</td>
				<td>#dateFormat(updated,"short")# #timeFormat(updated,"short")#</td>
				<td><a href="campaigns.cfm?deleteCampaign=#id#">Delete</a> / <a href="campaigns.cfm?resetStats=#id#">Reset</a></td>
			</tr>
		</cfloop>
	</table>
<cfelse>
	<p>
		There are no campaigns defined yet.
	</p>
</cfif>

<p>
<a href="campaign_edit.cfm">New Campaign</a>
</p>

</cfoutput>


</cfmodule>
