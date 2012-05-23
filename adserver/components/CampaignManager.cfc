<cfcomponent output="false" displayName="Campaign Manager">

	<cfset variables.dsn = "">
	
	<cffunction name="init" access="public" returnType="CampaignManager" output="false">
		<cfargument name="dsn" type="string" required="true">
		
		<cfset variables.dsn = arguments.dsn>
		<cfreturn this>
	</cffunction>	


	<cffunction name="getCampaigns" access="public" returnType="query" output="false"
				hint="Gets all the campaigns.">		
		<cfset var data = "">
		
		<cfquery name="data" datasource="#variables.dsn#">
			<!--- This SQL was given to me by Shlomy --->
			select 	distinct campaigns.id, campaigns.name, campaigns.active, campaigns.created, campaigns.updated, 
			count(ads_impressions.thetime) as impressions,
			(select count(ads_clicks.thetime) from ads_clicks where ads_clicks.campaignidfk = campaigns.id) as clicks
			from	campaigns left join ads_impressions on campaigns.id = ads_impressions.campaignidfk
			group by campaigns.id, campaigns.name, campaigns.created, campaigns.updated, campaigns.active 
			<!---
				  This wonderful sql was provided to my Emily Kim - but it only works in SQL Server, 
				  so I had to revert. :(
			select distinct campaigns.id,  
			campaigns.name,  
			campaigns.created,  
			campaigns.updated,  
			campaigns.active,  
			a.impressions,  
			b.clicks  
			from campaigns  
			left join   (select ads_impressions.campaignidfk as campaignid ,  
			count(ads_impressions.timestamp) as impressions  
			               from ads_impressions group by ads_impressions.campaignidfk)  
			a on campaigns.id = a.campaignid  
			left join   (select ads_clicks.campaignidfk as campaignid,  
			count(ads_clicks.timestamp) as clicks  
			               from ads_clicks group by ads_clicks.campaignidfk) b on  
			campaigns.id = b.campaignid  
			--->
		</cfquery>

		<cfreturn data>
	</cffunction>

	<cffunction name="getCampaignStats" access="public" returnType="struct" output="false"
				hint="Slow method to get stats for campaigns.">
		<cfargument name="cids" type="string" required="false" hint="Campaign IDs">
		<cfset var camps = getCampaigns()>
		<cfset var result = structNew()>
		<cfset var getImp = "">
		<cfset var getClick = "">
		<cfset var impdata_day = structNew()>
		<cfset var impdata_hour = structNew()>
		<cfset var clickdata_day = structNew()>
		<cfset var clickdata_hour = structNew()>
		<cfset var addata = structNew()>
		
		<!--- filter out --->
		<cfif isDefined("arguments.cids") and len(arguments.cids)>
			<cfquery name="camps" dbtype="query">
			select	*
			from	camps
			where	id in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cids#" list="yes">)
			</cfquery>
		</cfif>
		
		<!--- 
			Now lets add our stats columns:
			impressionquery = query of impressions
			totalimpressions = duh
			firstimpression = duh
			lastimpression = duh
			
			clickquery = query of clicks
			totalclicks = duh
			firstclick = duh
			lastclick = duh	
			
			impdata_day - struct of days and impressions
			impdata_hour - guess
			clickdata_day - ditto
			clickdata_hour - ditto
			
			ctr - clickthrough rate
			
			ads - struct of impressions and clicks
		--->
		<cfloop query="camps">
			<cfset results[id] = structNew()>
			<cfset impdata_day = structNew()>
			<cfset impdata_hour = structNew()>
			<cfset clickdata_day = structNew()>
			<cfset clickdata_hour = structNew()>
			<cfset addata = structNew()>
			
			<cfset results[id].name = name>
			
			<!--- get impressions --->
			<cfquery name="getImp" datasource="#application.dsn#">
			select		adidfk, thetime
			from		ads_impressions
			where		campaignidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#" maxlength="35">
			order by	thetime asc
			</cfquery>
			<cfset results[id].impressionquery = duplicate(getImp)>
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
				<cfif not structKeyExists(addata,adidfk)>
					<cfset addata[adidfk] = structNew()>
					<cfset addata[adidfk].clicks = 0>
					<cfset addata[adidfk].impressions = 0>
				</cfif>	
				<cfset addata[adidfk].impressions = addata[adidfk].impressions+1>
			</cfloop>
			<cfset results[id].impdata_day = impdata_day>
			<cfset results[id].impdata_hour = impdata_hour>
			
			<!--- get clicks --->
			<cfquery name="getClick" datasource="#application.dsn#">
			select		adidfk, thetime
			from		ads_clicks
			where		campaignidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#" maxlength="35">
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
				<cfif not structKeyExists(addata,adidfk)>
					<cfset addata[adidfk] = structNew()>
					<cfset addata[adidfk].clicks = 0>
					<cfset addata[adidfk].impressions = 0>
				</cfif>	
				<cfset addata[adidfk].clicks = addata[adidfk].clicks+1>
			</cfloop>
			<cfset results[id].clickdata_day = clickdata_day>
			<cfset results[id].clickdata_hour = clickdata_hour>
			<cfset results[id].addata = addata>
			
			<cfif results[id].totalimpressions gte 1>
				<cfset results[id].ctr = results[id].totalclicks/ results[id].totalimpressions>
			<cfelse>
				<cfset results[id].ctr = 0>
			</cfif>		
		</cfloop>
		
		<cfreturn results>		
	</cffunction>
	
	<cffunction name="addAd" access="public" returnType="void" roles="admin" output="false"
				hint="This adds an ad to the campaign.">
		<cfargument name="campaignidfk" type="uuid" required="true" hint="Campaign ID">
		<cfargument name="adidfk" type="uuid" required="true" hint="Ad ID">
		<cfargument name="weight" type="numeric" required="true" hint="Weight of the ad.">
		<cfargument name="datebegin" type="date" required="false" hint="Ads will only show up AFTER this date.">
		<cfargument name="dateend" type="date" required="false" hint="Ads will only show up BEFORE this date.">
		<cfargument name="timebegin" type="date" required="false" hint="Ads will only show up AFTER this time.">
		<cfargument name="timeend" type="date" required="false" hint="Ads will only show up BEFORE this time.">
		
		<!--- double check valid campaign --->
		<cfif not validCampaign(arguments.campaignidfk)>
			<cfset throw("Invalid Campaign IDFK passed.")>
		</cfif>
		
		<cfquery datasource="#variables.dsn#">
		insert into campaigns_ads(id, campaignidfk, adidfk, weight, datebegin, dateend, timebegin, timeend)
		values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#createUUID()#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.campaignidfk#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adidfk#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.weight#">
			<cfif isDefined("arguments.datebegin")>
				,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.datebegin#">
			<cfelse>
				,<cfqueryparam cfsqltype="cf_sql_timestamp" null=true>
			</cfif>
			<cfif isDefined("arguments.dateend")>
				,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.dateend#">
			<cfelse>
				,<cfqueryparam cfsqltype="cf_sql_timestamp" null=true>
			</cfif>
			<cfif isDefined("arguments.timebegin")>
				,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.timebegin#">
			<cfelse>
				,<cfqueryparam cfsqltype="cf_sql_timestamp" null=true>
			</cfif>
			<cfif isDefined("arguments.timeend")>
				,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.timeend#">
			<cfelse>
				,<cfqueryparam cfsqltype="cf_sql_timestamp" null=true>
			</cfif>
			)
		</cfquery>
		
	</cffunction>

	<cffunction name="deleteAd" access="public" returnType="void" roles="admin" output="false"
				hint="This removes an ad from a campaign.">
		<cfargument name="campaignidfk" type="uuid" required="true" hint="Campaign ID">
		<cfargument name="id" type="uuid" required="true" hint="Scheduled Ad ID">
		<cfset var getAdId = "">
		<cfset var adId = "">
		
		<!--- ID is the PK of the campains_ads table, we need the particular ad id though --->
		<cfquery name="getAdId" datasource="#variables.dsn#">
		select	adidfk
		from	campaigns_ads
		where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		and		campaignidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.campaignidfk#" maxlength="35">
		</cfquery>
		
		<cfif not getAdId.recordCount>
			<cfreturn>
		<cfelse>
			<cfset adId = getAdid.adidfk>
		</cfif>
				
		<cfquery datasource="#variables.dsn#">
		delete	from campaigns_ads
		where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		and		campaignidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.campaignidfk#" maxlength="35">
		</cfquery>
		
		<!--- clean up stats --->
		<cfquery datasource="#variables.dsn#">
		delete	from ads_clicks
		where	campaignidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.campaignidfk#" maxlength="35">
		and		adidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#adId#" maxlength="35">
		</cfquery>
		<cfquery datasource="#variables.dsn#">
		delete	from ads_impressions
		where	campaignidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.campaignidfk#" maxlength="35">
		and		adidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#adId#" maxlength="35">
		</cfquery>
		
	</cffunction>

	<cffunction name="editAd" access="public" returnType="void" roles="admin" output="false"
				hint="This edits an ad scheduled to the campaign.">
		<cfargument name="scheduledadid" type="uuid" required="true" hint="Schedul ID">
		<cfargument name="campaignidfk" type="uuid" required="true" hint="Campaign ID">
		<cfargument name="adidfk" type="uuid" required="true" hint="Ad ID">
		<cfargument name="weight" type="numeric" required="true" hint="Weight of the ad.">
		<cfargument name="datebegin" type="date" required="false" hint="Ads will only show up AFTER this date.">
		<cfargument name="dateend" type="date" required="false" hint="Ads will only show up BEFORE this date.">
		<cfargument name="timebegin" type="date" required="false" hint="Ads will only show up AFTER this time.">
		<cfargument name="timeend" type="date" required="false" hint="Ads will only show up BEFORE this time.">
		
		<!--- double check valid campaign --->
		<cfif not validCampaign(arguments.campaignidfk)>
			<cfset throw("Invalid Campaign IDFK passed.")>
		</cfif>

		<cfquery datasource="#variables.dsn#">
		update campaigns_ads
		set 	campaignidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.campaignidfk#" maxlength="35">,
				adidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adidfk#" maxlength="35">,
				weight = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.weight#">
				,datebegin = 
				<cfif isDefined("arguments.datebegin")>
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.datebegin#">
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_timestamp" null=true>
				</cfif>
				,dateend = 
				<cfif isDefined("arguments.dateend")>
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.dateend#">
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_timestamp" null=true>
				</cfif>
				,timebegin = 
				<cfif isDefined("arguments.timebegin")>
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.timebegin#">
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_timestamp" null=true>
				</cfif>
				,timeend = 
				<cfif isDefined("arguments.timeend")>
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.timeend#">
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_timestamp" null=true>
				</cfif>																
		where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheduledadid#" maxlength="35">
		</cfquery>
		
	</cffunction>
	
	<cffunction name="getScheduledAds" access="public" returnType="query" roles="" output="false"
				hint="Returns all the ads scheduled to a campaign.">
		<cfargument name="campaignidfk" type="uuid" required="true" hint="Campaign ID">
		<cfset var data = "">
		
		<cfquery name="data" datasource="#variables.dsn#">
		select	campaigns_ads.id, campaigns_ads.adidfk, campaigns_ads.weight, campaigns_ads.datebegin, campaigns_ads.dateend, campaigns_ads.timebegin, campaigns_ads.timeend, ads.name as adname
		from	campaigns_ads, ads
		where	campaignidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.campaignidfk#" maxlength="35">
		and		campaigns_ads.adidfk = ads.id
		and		ads.active = 1
		</cfquery>
		
		<cfreturn data>
		
	</cffunction>	

	<cffunction name="resetStats" access="public" returnType="void" roles="" output="false"
				hint="Resets all stats for a campaign.">
		<cfargument name="campaignidfk" type="uuid" required="true" hint="Campaign ID">

		<!--- clean up stats --->
		<cfquery datasource="#variables.dsn#">
		delete	from ads_clicks
		where	campaignidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.campaignidfk#" maxlength="35">
		</cfquery>

		<cfquery datasource="#variables.dsn#">
		delete	from ads_impressions
		where	campaignidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.campaignidfk#" maxlength="35">
		</cfquery>

	</cffunction>
		
	<cffunction name="validCampaign" access="private" returnType="boolean" output="false"
				hint="Returns true if a campaign exists.">
		<cfargument name="campaignidfk" type="uuid" required="true" hint="Campaign ID">
		<cfset var getit = "">
		
		<cfquery name="getit" datasource="#variables.dsn#">
		select	id
		from	campaigns
		where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.campaignidfk#" maxlength="35">
		</cfquery>
		
		<cfreturn getit.recordCount gte 1>
				
	</cffunction>
	
	<cffunction name="throw" access="private" returnType="void" output="false"
				hint="Internal throw method.">
		<cfargument name="message" type="string" required="true">
	
		<cfthrow type="CampaignManager" message="#arguments.message#">
	
	</cffunction>
			
</cfcomponent>