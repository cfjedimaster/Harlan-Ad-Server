<!---
	Name:			/ads.cfm
	Last Updated:	5/28/07
	History:		Support for resetting ads
--->

<cfif isDefined("url.deleteAd")>
	<cfset application.adDAO.delete(url.deleteAd)>
	<cflocation url="ads.cfm?msg=success:::delete successfully." addToken="false">
</cfif>

<cfif isDefined("url.resetStats")>
	<cfset application.adManager.resetStats(url.resetStats)>
	<cflocation url="ads.cfm" addToken="false">
</cfif>

<cfmodule template="tags/layout.cfm" title="#application.title# - Ads">

<cfset ads = application.adManager.getAds()>
<cfset queryAddColumn(ads,"code",arrayNew(1))>

<cfloop query="ads">
	<cfset querySetCell(ads,"code",trim(application.utils.getLinkCode(adid=id)),currentRow)>
</cfloop>

<cfoutput>
<h2>Ads</h2>
<p class="row">
	<a href="ad_edit.cfm" class="btn btn-success pull-right">
		<i class="icon-plus icon-white">
		</i>
		New Ad
	</a>
</p>
<cfif ads.recordCount>
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
			<cfloop query="ads">
				<tr valign="top">
					<td><a href="ad_edit.cfm?id=#id#">#name#</a><br/>#clientname#</td>
					<td>#numberFormat(impressions)#</td>
					<td>#numberFormat(clicks)#</td>
					<td>#yesNoFormat(active)#</td>
					<td>#dateFormat(updated,"short")# #timeFormat(updated,"short")#</td>
					<td width="150px">
						<a href="ad_edit.cfm?id=#id#" class="icon-pencil" rel="tooltip" title="Edit ad"></a> &nbsp; &nbsp;| &nbsp; &nbsp; 
						<a class="icon-trash" href="javascript:void(0);"  rel="tooltip" title="Delete ad" onclick="javascript:confirmDelete('ads.cfm?deleteAd=#id#')"> </a> &nbsp; &nbsp;| &nbsp; &nbsp; 
						<a href="ads.cfm?resetStats=#id#" class="icon-refresh" rel="tooltip" title="Reset ad"></a></td>
				</tr>
			</cfloop>
		</tbody>
	</table>
<cfelse>
	<p class="alert alert-error">
		<i class="icon-white icon-warning-sign"></i><strong> There are no ads defined yet.</strong>
	</p>
</cfif>
<!---<p>
<a href="ad_edit.cfm">New Ad</a>
</p>--->

</p>
</cfoutput>

</cfmodule>
