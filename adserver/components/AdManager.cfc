<cfcomponent output="false" displayName="Ad Manager">

	<cfset variables.dsn = "">
	<cfset variables.adDAO = "">
	
	<cffunction name="init" access="public" returnType="AdManager" output="false">
		<cfargument name="dsn" type="string" required="true">
		
		<cfset variables.dsn = arguments.dsn>
		<cfset variables.adDAO = createObject("component", "AdDAO").init(variables.dsn)>
		
		<cfreturn this>
	</cffunction>	
		
	<cffunction name="addClick" access="public" returnType="void" output="false"
				hint="Adds a click.">
		<cfargument name="adid" type="uuid" required="true" hint="Ad ID">
		<cfargument name="cid" type="uuid" required="false" hint="Campaign ID">
		<cfargument name="time" type="date" required="false" default="#now()#" hint="Timestamp. Normally not used.">
		
		<cfset ad = variables.adDAO.read(arguments.adid)>
		
		<cfif ad.getID() neq arguments.adid>
			<cfreturn "">
		</cfif>
		
		<!--- update impressions --->
		<cfquery datasource="#variables.dsn#">
		insert into ads_clicks(thetime, adidfk, campaignidfk)
		values(
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.time#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adid#" maxlength="35">,
			<cfif isDefined("arguments.cid")>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cid#" maxlength="35">
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_varchar" null=true>
			</cfif>)
		</cfquery>
				
	</cffunction>
		
	<cffunction name="getAds" access="public" returnType="query" output="false"
				hint="Gets all the ads.">		
		<cfargument name="bActiveOnly" type="boolean" required="false" default="false">
		<cfset var data = "">
		
		<cfquery name="data" datasource="#variables.dsn#">
			<!---
				As before, I'd like to thank Shlomy G. for this SQL. I couldn't 
				get it working right in Access and he made it work!
			--->
			SELECT DISTINCT ads.id, ads.name, ads.active, ads.created, ads.updated,
			Count(ads_impressions.thetime) AS impressions, (select
			count(ads_clicks.thetime) from ads_clicks where ads_clicks.adidfk = ads.id)
			AS clicks, clients.name as clientname
			FROM (ads LEFT JOIN ads_impressions ON ads.id = ads_impressions.adidfk)
			INNER JOIN clients ON ads.clientidfk = clients.id
			<cfif arguments.bActiveOnly>
			where			ads.active = 1
			</cfif>
			GROUP BY ads.id, ads.name, ads.active, ads.created, ads.updated, clients.name 
		</cfquery>

		<cfreturn data>
	</cffunction>
	
	<cffunction name="getAdImpression" access="public" returnType="adBean" output="false"
				hint="Gets the bean for an ad and ads one to impressions.">
		<cfargument name="adid" type="uuid" required="true" hint="Ad ID">
		<cfargument name="cid" type="uuid" required="false" hint="Campaign ID">
		<cfargument name="time" type="date" required="false" default="#now()#" hint="Timestamp. Normally not used.">
	
		<cfset ad = variables.adDAO.read(arguments.adid)>
		
		<cfif ad.getID() neq arguments.adid or not ad.getActive()>
			<cfreturn ad>
		</cfif>
		
		<!--- update impressions --->
		<cfquery datasource="#variables.dsn#">
		insert into ads_impressions(thetime, adidfk, campaignidfk)
		values(
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.time#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adid#" maxlength="35">,
			<cfif isDefined("arguments.cid")>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cid#" maxlength="35">
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_varchar" null=true>
			</cfif>)
		</cfquery>
		
		<!--- Need to mod this to return text... --->
		<cfreturn ad>
		
	</cffunction>

	<cffunction name="getAdStats" access="public" returnType="struct" output="false"
				hint="Gets a bunch of stats for ads.">
		<cfargument name="aids" type="string" required="false" hint="Ads IDs">
		<cfset var ads = getAds()>
		<cfset var results = structNew()>
		<cfset var getImp = "">
		<cfset var getClick = "">
		<cfset var impdata_day = structNew()>
		<cfset var impdata_hour = structNew()>
		<cfset var clickdata_day = structNew()>
		<cfset var clickdata_hour = structNew()>
		
		<!--- filter out --->
		<cfif isDefined("arguments.aids") and len(arguments.aids)>
			<cfquery name="ads" dbtype="query">
			select	*
			from	ads
			where	id in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aids#" list="yes">)
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
			
		--->
		<cfloop query="ads">
			<cfset results[id] = structNew()>
			<cfset impdata_day = structNew()>
			<cfset impdata_hour = structNew()>
			<cfset clickdata_day = structNew()>
			<cfset clickdata_hour = structNew()>
			
			<cfset results[id].name = name>
			
			<!--- get impressions --->
			<cfquery name="getImp" datasource="#application.dsn#">
			select		adidfk, thetime
			from		ads_impressions
			where		adidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#" maxlength="35">
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
			from		ads_clicks
			where		adidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#" maxlength="35">
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

	<cffunction name="resetStats" access="public" returnType="void" roles="" output="false"
				hint="Resets all stats for an ad.">
		<cfargument name="adidfk" type="uuid" required="true" hint="Ad ID">

		<!--- clean up stats --->
		<cfquery datasource="#variables.dsn#">
		delete	from ads_clicks
		where	adidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adidfk#" maxlength="35">
		</cfquery>

		<cfquery datasource="#variables.dsn#">
		delete	from ads_impressions
		where	adidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adidfk#" maxlength="35">
		</cfquery>

	</cffunction>
					
</cfcomponent>