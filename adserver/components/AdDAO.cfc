<cfcomponent output="false" displayName="Ad DAO" hint="Does DAO for Ads">

	<cfset variables.dsn = "">
	
	<cffunction name="init" access="public" returnType="AdDAO" output="false">
		<cfargument name="dsn" type="string" required="true">
		
		<cfset variables.dsn = arguments.dsn>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="create" access="public" returnType="AdBean" output="false">
		<cfargument name="aBean" type="AdBean" required="true">
		<cfset var insRec = "">
		<cfset var newID = createUUID()>
		
			
		<cfquery name="insRec" datasource="#variables.dsn#">
			insert into ads(id,clientidfk,name,source,
			<cfif arguments.aBean.getHeight() neq "">height,</cfif>
			<cfif arguments.aBean.getWidth() neq "">width,</cfif>
			title,body,url,active,created,updated,target,html)
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#newid#" maxlength="35">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aBean.getClientIDFK()#" maxlength="35">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aBean.getName()#" maxlength="50">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aBean.getSource()#" maxlength="255">,
				<cfif arguments.aBean.getHeight() neq "">
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.aBean.getHeight()#">,
				</cfif>
				<cfif arguments.aBean.getWidth() neq "">
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.aBean.getWidth()#">,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aBean.getTitle()#" maxlength="255">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aBean.getBody()#" maxlength="255">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aBean.getURL()#" maxlength="255">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.aBean.getActive()#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.aBean.getCreated()#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.aBean.getUpdated()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aBean.getTarget()#" maxlength="255">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.aBean.getHTML()#">
				)
		</cfquery>
			
		<cfset aBean.setID(newid)>
				
		<cfreturn aBean>
	</cffunction>
	
	<cffunction name="delete" access="public" returnType="void" output="false">
		<cfargument name="id" type="uuid" required="true">

		<cfquery datasource="#variables.dsn#">
		delete from ads
		where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
					
		<!--- remove from campaigns --->
		<cfquery datasource="#variables.dsn#">
		delete from campaigns_ads
		where adidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>

		<!--- delete from stats --->
		<cfquery datasource="#variables.dsn#">
		delete from ads_impressions
		where adidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>

		<cfquery datasource="#variables.dsn#">
		delete from ads_clicks
		where adidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
			
	</cffunction>
	
	<cffunction name="read" access="public" returnType="AdBean" output="false">
		<cfargument name="id" type="uuid" required="true">
		<cfset var aBean = createObject("component","AdBean")>
		<cfset var getit = "">
		
		<cfquery name="getit" datasource="#variables.dsn#">
			select 	id, clientidfk, name, source, height, width, title, body, url, active, created, updated, target, html
			from	ads
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
		
		<cfif getit.recordCount>
			<cfset aBean.setID(getit.id)>
			<cfset aBean.setClientIDFK(getit.clientidfk)>
			<cfset aBean.setName(getit.name)>
			<cfset aBean.setSource(getit.source)>
			<cfset aBean.setHeight(getit.height)>
			<cfset aBean.setWidth(getit.width)>
			<cfset aBean.setTitle(getit.title)>
			<cfset aBean.setBody(getit.body)>
			<cfset aBean.setURL(getit.url)>
			<cfset aBean.setActive(getit.active)>
			<cfset aBean.setCreated(getit.created)>
			<cfset aBean.setUpdated(getit.updated)>
			<cfset aBean.setTarget(getit.target)>
			<cfset aBean.setHTML(getit.html)>
		</cfif>
		
		<cfreturn aBean>
	</cffunction>

	<cffunction name="update" returnType="AdBean" access="public" output="false">
		<cfargument name="aBean" type="AdBean" required="true">

		<cfquery datasource="#variables.dsn#">
		update ads
		set	clientidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aBean.getClientIDFK()#" maxlength="35">,
			name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aBean.getName()#" maxlength="50">,
			source = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aBean.getSource()#" maxlength="255">,
			<cfif arguments.aBean.getHeight() neq "">
				height = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.aBean.getHeight()#">,
			</cfif>
			<cfif arguments.aBean.getWidth() neq "">
				width = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.aBean.getWidth()#">,
			</cfif>
			title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aBean.getTitle()#" maxlength="255">,
			body = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aBean.getBody()#" maxlength="255">,
			url = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aBean.getURL()#" maxlength="255">,
			active = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.aBean.getActive()#">,
			created = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.aBean.getCreated()#">,
			updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.aBean.getUpdated()#">,
			target = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aBean.getTarget()#" maxlength="255">,
			html = 	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.aBean.getHTML()#">
			where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aBean.getID()#" maxlength="35">
		</cfquery>				

		<cfreturn arguments.aBean>
	</cffunction>
	
</cfcomponent>