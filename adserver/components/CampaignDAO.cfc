<cfcomponent output="false" displayName="Campaign DAO" hint="Does DAO for Campaign">

	<cfset variables.dsn = "">
	
	<cffunction name="init" access="public" returnType="CampaignDAO" output="false">
		<cfargument name="dsn" type="string" required="true">
		
		<cfset variables.dsn = arguments.dsn>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="create" access="public" returnType="CampaignBean" output="false">
		<cfargument name="cBean" type="CampaignBean" required="true">
		<cfset var insRec = "">
		<cfset var newID = createUUID()>
		
			
		<cfquery name="insRec" datasource="#variables.dsn#">
			insert into campaigns(id,name,active,created,updated)
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#newid#" maxlength="35">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cBean.getName()#" maxlength="50">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.cBean.getActive()#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.cBean.getCreated()#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.cBean.getUpdated()#">
				)
		</cfquery>
			
		<cfset cBean.setID(newid)>
		
		<cfreturn cBean>
	</cffunction>
	
	<cffunction name="delete" access="public" returnType="void" output="false">
		<cfargument name="id" type="uuid" required="true">

		<cfquery datasource="#variables.dsn#">
		delete from campaigns
		where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
			
		<!--- clean up campaigns_ads --->
		<cfquery datasource="#variables.dsn#">
		delete from campaigns_ads
		where campaignidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
		
		<!--- clean up stats --->
		<cfquery datasource="#variables.dsn#">
		delete from ads_clicks
		where campaignidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>

		<cfquery datasource="#variables.dsn#">
		delete from ads_impressions
		where campaignidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>

	</cffunction>
	
	<cffunction name="read" access="public" returnType="CampaignBean" output="false">
		<cfargument name="id" type="uuid" required="true">
		<cfset var cBean = createObject("component","CampaignBean")>
		<cfset var getit = "">
		
		<cfquery name="getit" datasource="#variables.dsn#">
			select 	id, name, created, updated, active
			from	campaigns
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
		
		<cfif getit.recordCount>
			<cfset cBean.setID(getit.id)>
			<cfset cBean.setName(getit.name)>
			<cfset cBean.setActive(getit.active)>
			<cfset cBean.setCreated(getit.created)>
			<cfset cBean.setUpdated(getit.updated)>			
		</cfif>
		
		<cfreturn cBean>
	</cffunction>

	<cffunction name="update" returnType="CampaignBean" access="public" output="false">
		<cfargument name="CampaignBean" type="CampaignBean" required="true">

		<cfquery datasource="#variables.dsn#">
		update campaigns
		set name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CampaignBean.getName()#" maxlength="50">,
		active = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.CampaignBean.getActive()#">,
		created = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.CampaignBean.getCreated()#">,
		updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.CampaignBean.getUpdated()#">
		where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CampaignBean.getID()#" maxlength="35">
		</cfquery>
		
		<cfreturn arguments.CampaignBean>
	</cffunction>
	
</cfcomponent>