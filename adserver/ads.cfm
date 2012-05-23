<!---
	Name:			/ads.cfm
	Last Updated:	5/28/07
	History:		Support for resetting ads
--->

<cfif isDefined("url.deleteAd")>
	<cfset application.adDAO.delete(url.deleteAd)>
	<cflocation url="ads.cfm" addToken="false">
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

<cfif ads.recordCount>
	<table class="mainTable">
		<tr>
			<th>Name</th>
			<th>Impressions</th>
			<th>Clicks</th>
			<th>Active</th>
			<th>Updated</th>
			<td>&nbsp;</td>
		</tr>
		<cfloop query="ads">
			<tr valign="top">
				<td><a href="ad_edit.cfm?id=#id#">#name#</a><br/>#clientname#</td>
				<td>#numberFormat(impressions)#</td>
				<td>#numberFormat(clicks)#</td>
				<td>#yesNoFormat(active)#</td>
				<td>#dateFormat(updated,"short")# #timeFormat(updated,"short")#</td>
				<td><a href="ads.cfm?deleteAd=#id#">Delete</a> / <a href="ads.cfm?resetStats=#id#">Reset</a></td>
			</tr>
		</cfloop>
	</table>
<cfelse>
	<p>
		There are no ads defined yet.
	</p>
</cfif>
<p>
<a href="ad_edit.cfm">New Ad</a>
</p>

</p>
</cfoutput>

</cfmodule>
