<cfcomponent output="false" displayName="Client Manager">

	<cfset variables.dsn = "">

	<cffunction name="init" access="public" returnType="ClientManager" output="false">
		<cfargument name="dsn" type="string" required="true">
		
		<cfset variables.dsn = arguments.dsn>
		
		<cfreturn this>
	</cffunction>	
		
	<cffunction name="getClients" access="public" returnType="query" output="false"
				hint="Gets all the clients.">		
		
		<cfset var data = "">

		<cfquery name="data" datasource="#variables.dsn#">
			select 		clients.id, clients.name, clients.emailaddress, clients.notes 
			from		clients
			order by	clients.name asc
		</cfquery>

		<cfreturn data>
	</cffunction>

	<cffunction name="getClientStats" access="public" returnType="struct" output="false"
				hint="Gets a bunch of stats for clients.">
		<cfargument name="cids" type="string" required="false" hint="Ads IDs">
		<cfset var clients = getClients()>
		<cfset var results = structNew()>
		<cfset var getImp = "">
		<cfset var getClick = "">
		<cfset var impdata_day = structNew()>
		<cfset var impdata_hour = structNew()>
		<cfset var clickdata_day = structNew()>
		<cfset var clickdata_hour = structNew()>
		<cfset var adCount = structNew()>
		<cfset var getCount = "">
		
		<!--- filter out --->
		<cfif isDefined("arguments.cids") and len(arguments.cids)>
			<cfquery name="clients" dbtype="query">
			select	*
			from	clients
			where	id in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cids#" list="yes">)
			</cfquery>
		</cfif>

		<!--- 
			Now lets add our stats columns:
			totalimpressions = duh
			firstimpression = duh
			lastimpression = duh
			
			totalclicks = duh
			firstclick = duh
			lastclick = duh	
			
			impdata_day - struct of days and impressions
			impdata_hour - guess
			clickdata_day - ditto
			clickdata_hour - ditto
			
			ctr - clickthrough rate
			
			addCount - # of ads
			
		--->
		<cfloop query="clients">
			<cfset results[id] = structNew()>
			<cfset impdata_day = structNew()>
			<cfset impdata_hour = structNew()>
			<cfset clickdata_day = structNew()>
			<cfset clickdata_hour = structNew()>
			<cfset adCount = 0>
			
			<cfset results[id].name = name>
			
			<!--- get ad count --->
			<cfquery name="getCount" datasource="#application.dsn#">
			select	count(id) as totalAds
			from	ads
			where	clientidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#" maxlength="35">
			</cfquery>
			<cfset results[id].adCount = getCount.totalAds>
			
			<!--- get impressions --->
			<cfquery name="getImp" datasource="#application.dsn#">
			select		adidfk, thetime
			from		ads_impressions, ads
			where		ads_impressions.adidfk = ads.id
			and			ads.clientidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#" maxlength="35">
			order by	thetime asc
			</cfquery>
			<cfset results[id].totalimpressions = getImp.recordCount>
			<cfset results[id].firstimpression = getImp.thetime[1]>
			<cfset results[id].lastimpression = getImp.thetime[getImp.recordCount]>
			
			<cfloop query="getImp">
				<cfset theDay = dateFormat(thetime,"mm/dd/yy")>
				<cfset theHour = timeFormat(thetime,"HH")>
				<cfif not structKeyExists(impdata_day,theDay)>
					<cfset impdata_day[theDay] = 1>
				<cfelse>
					<cfset impdata_day[theDay] = impdata_day[theDay]+1>
				</cfif>
				<cfif not structKeyExists(impdata_hour,theHour)>
					<cfset impdata_hour[theHour] = 1>
				<cfelse>
					<cfset impdata_hour[theHour] = impdata_hour[theHour]+1>
				</cfif>
			</cfloop>
			<cfset results[id].impdata_day = impdata_day>
			<cfset results[id].impdata_hour = impdata_hour>
			
			<!--- get clicks --->
			<cfquery name="getClick" datasource="#application.dsn#">
			select		adidfk, thetime
			from		ads_clicks, ads
			where		ads_clicks.adidfk = ads.id
			and			ads.clientidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#" maxlength="35">
			order by	thetime asc
			</cfquery>
			<cfset results[id].clickquery = duplicate(getClick)>
			<cfset results[id].totalclicks = getClick.recordCount>
			<cfset results[id].firstclick = getClick.thetime[1]>
			<cfset results[id].lastclick = getClick.thetime[getClick.recordCount]>

			<cfloop query="getClick">
				<cfset theDay = dateFormat(thetime,"mm/dd/yy")>
				<cfset theHour = timeFormat(thetime,"HH")>
				<cfif not structKeyExists(clickdata_day,theDay)>
					<cfset clickdata_day[theDay] = 1>
				<cfelse>
					<cfset clickdata_day[theDay] = clickdata_day[theDay]+1>
				</cfif>
				<cfif not structKeyExists(clickdata_hour,theHour)>
					<cfset clickdata_hour[theHour] = 1>
				<cfelse>
					<cfset clickdata_hour[theHour] = clickdata_hour[theHour]+1>
				</cfif>
			</cfloop>
			<cfset results[id].clickdata_day = clickdata_day>
			<cfset results[id].clickdata_hour = clickdata_hour>
			
			<cfif results[id].totalimpressions gte 1>
				<cfset results[id].ctr = results[id].totalclicks/ results[id].totalimpressions>
			<cfelse>
				<cfset results[id].ctr = 0>
			</cfif>		
		</cfloop>
		
		<cfreturn results>
	</cffunction>				
</cfcomponent>