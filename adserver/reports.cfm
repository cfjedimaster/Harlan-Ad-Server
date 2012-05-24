<!---
	Name:			/reports.cfm
	Last Updated:	06/02/05
	History:
--->

<cfmodule template="tags/layout.cfm" title="#application.title# - Reports">

<cfoutput>
<h2>Reports</h2>
<p>
This application allows you to serve ads on your web site. To begin, create one or more clients. Then you can
upload banner images to be used as advertisements. Advertisements can either be used alone or served within
campaigns. Reporting options allow you to see how well your ads, clients, and campaigns are doing. 
</p>


<cfset campaigns = application.campaignManager.getCampaigns()>
<p>
<form action="reports_campaigns.cfm" method="post" class="well">
<fieldset title="Campaigns">
<legend>Campaigns</legend>
<p>
The following options allow you to create reports for campaigns. The HTML reports includes stats for campaigns as well
as ads scheduled to them. The Excel report is more of a simple summary of campagin stats.
</p>
<cfif campaigns.recordCount>
	<table>
		<tr valign="top">
			<td><label for="campaigns">Campaign:</label></td>
			<td>
			<select name="campaigns" id="campaigns" <cfif campaigns.recordCount gte 2>multiple size="5"</cfif>>
			<cfif campaigns.recordCount gte 2><option value="" selected>All Campaigns</option></cfif>
			<cfloop query="campaigns">
			<option value="#id#">#name#</option>
			</cfloop>
			</select>
			</td>
		</tr>
		<tr>
			<td><label for="style">Style:</label></td>
			<td>
			<select name="style">
			<option value="html">HTML</option>
			<option value="excel">Excel</option>
			</select>
			</td>
		</tr>
	</table>
	<div class="form-actions">
		<input type="submit" class="btn" value="Generate Report">
	</div>
<cfelse>
	<p class="alert alert-error">
		<i class="icon-white icon-warning-sign"></i><strong> 
	Sorry, but you do not have any campaigns to report on.</strong> 
	</p>
</cfif>
</fieldset>
</form>
</p>

<cfset ads = application.adManager.getAds()>
<p>
<form action="reports_ads.cfm" method="post" class="well">
<fieldset title="Ads">
<legend>Ads</legend>
<p>
The following options allow you to create reports for ads. Both the HTML and Excel reports contain data for each
ad specified.
</p>
<cfif ads.recordCount>
	<table>
		<tr valign="top">
			<td><label for="ads">Ad:</label></td>
			<td>
			<select name="ads" id="ads" <cfif ads.recordCount gte 2>multiple size="5"</cfif>>
			<cfif ads.recordCount gte 2><option value="" selected>All Ads</option></cfif>
			<cfloop query="ads">
			<option value="#id#">#name#</option>
			</cfloop>
			</select>
			</td>
		</tr>
		<tr>
			<td><label for="style">Style:</label></td>
			<td>
			<select name="style">
			<option value="html">HTML</option>
			<option value="excel">Excel</option>
			</select>
			</td>
		</tr>	
	</table>
	<div class="form-actions">
		<input type="submit" class="btn" value="Generate Report">
	</div>
<cfelse>
	<p class="alert alert-error">
		<i class="icon-white icon-warning-sign"></i><strong> 
	Sorry, but you do not have any ads to report on.</strong> 
	</p>
</cfif>
</fieldset>
</form>
</p>

<cfset clients = application.clientManager.getClients()>
<p>
<form action="reports_clients.cfm" method="post" class="well">
<fieldset title="Clients">
<legend>Clients</legend>
<p>
The following options allow you to create reports for client. Both the HTML and Excel reports contain data for each
client specified.
</p>
<cfif clients.recordCount>
	<table>
		<tr valign="top">
			<td><label for="clients">Client:</label></td>
			<td>
			<select name="clients" id="clients" <cfif clients.recordCount gte 2>multiple size="5"</cfif>>
			<cfif clients.recordCount gte 2><option value="" selected>All Clients</option></cfif>
			<cfloop query="clients">
			<option value="#id#">#name#</option>
			</cfloop>
			</select>
			</td>
		</tr>
		<tr>
			<td><label for="style">Style:</label></td>
			<td>
			<select name="style">
			<option value="html">HTML</option>
			<option value="excel">Excel</option>
			</select>
			</td>
		</tr>
	</table>
	<div class="form-actions">
		<input type="submit" class="btn" value="Generate Report">
	</div>
<cfelse>
	<p class="alert alert-error">
		<i class="icon-white icon-warning-sign"></i><strong> 
	Sorry, but you do not have any clients to report on.</strong> 
	</p>
</cfif>
</fieldset>
</form>
</p>

</cfoutput>

</cfmodule>
