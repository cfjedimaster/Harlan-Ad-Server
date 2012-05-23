<cfsetting showdebugoutput=false>
<!---
	Name:			/adbouncer.cfm
	Last Updated:	06/02/05
	History:
	
	Notes:
	
	This is the receiver for ad clicks. We require at least an Ad ID, and optionally a campaign ID.
--->

<cfif not isDefined("url.a")>
	<cfabort>
</cfif>

<!--- validate the ad --->
<cfif not isValid("UUID",url.a)>
	<cfabort>
</cfif>
<cfset ad = application.adDAO.read(url.a)>
<cfif ad.getID() neq url.a or not ad.getActive()>
	<cfabort>
</cfif>

<!--- optionally validate the campaign --->
<cfif isDefined("url.c")>
	<cfif not isValid("UUID",url.c)>
		<cfabort>
	</cfif>
	<cfset campaign = application.campaignDAO.read(url.c)>
	<cfif campaign.getID() neq url.c or not campaign.getActive()>
		<cfabort>
	</cfif>
</cfif>

<!--- Ad a click --->
<cfinvoke component="#application.adManager#" method="addClick">
	<cfinvokeargument name="adid" value="#ad.getID()#">
	<cfif isDefined("url.c")>
		<cfinvokeargument name="cid" value="#campaign.getID()#">
	</cfif>
</cfinvoke>

<!--- Go away now. Please. --->
<cflocation url="#ad.getURL()#" addToken="false">
