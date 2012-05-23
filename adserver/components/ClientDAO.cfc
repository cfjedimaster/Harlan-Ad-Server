<cfcomponent output="false" displayName="Client DAO" hint="Does DAO for Clients">

	<cfset variables.dsn = "">
	
	<cffunction name="init" access="public" returnType="ClientDAO" output="false">
		<cfargument name="dsn" type="string" required="true">
		
		<cfset variables.dsn = arguments.dsn>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="create" access="public" returnType="ClientBean" output="false">
		<cfargument name="cBean" type="ClientBean" required="true">
		<cfset var insRec = "">
		<cfset var newID = createUUID()>
		
			
		<cfquery name="insRec" datasource="#variables.dsn#">
			insert into clients(id,name,emailaddress,notes)
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#newid#" maxlength="35">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cBean.getName()#" maxlength="255">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cBean.getEmailAddress()#" maxlength="255">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.cBean.getNotes()#">
				)
		</cfquery>
			
		<cfset cBean.setID(newid)>
				
		<cfreturn cBean>
	</cffunction>
	
	<cffunction name="delete" access="public" returnType="void" output="false">
		<cfargument name="id" type="uuid" required="true">
		<cfset var getAds = "">
		
		<cfquery datasource="#variables.dsn#">
		delete from clients
		where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>

		<!--- get my ads --->
		<cfquery name="getAds" datasource="#variables.dsn#">
		select	id
		from	ads
		where	clientidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
		
		<cfif getAds.recordCount>
			<cfquery datasource="#variables.dsn#">
			delete from ads
			where id in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(getAds.id)#" list="true" maxlength="35">)
			</cfquery>
						
			<!--- remove from campaigns --->
			<cfquery datasource="#variables.dsn#">
			delete from campaigns_ads
			where adidfk in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(getAds.id)#" list="true" maxlength="35">)
			</cfquery>
	
			<!--- delete from stats --->
			<cfquery datasource="#variables.dsn#">
			delete from ads_impressions
			where adidfk in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(getAds.id)#" list="true" maxlength="35">)
			</cfquery>
	
			<cfquery datasource="#variables.dsn#">
			delete from ads_clicks
			where adidfk in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valueList(getAds.id)#" list="true" maxlength="35">)
			</cfquery>
		</cfif>
										
	</cffunction>
	
	<cffunction name="read" access="public" returnType="ClientBean" output="false">
		<cfargument name="id" type="uuid" required="true">
		<cfset var cBean = createObject("component","ClientBean")>
		<cfset var getit = "">
		
		<cfquery name="getit" datasource="#variables.dsn#">
			select 	id, name, emailaddress, notes
			from	clients
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
		
		<cfif getit.recordCount>
			<cfset cBean.setID(getit.id)>
			<cfset cBean.setName(getit.name)>
			<cfset cBean.setEmailAddress(getit.emailaddress)>
			<cfset cBean.setNotes(getit.notes)>
		</cfif>
		
		<cfreturn cBean>
	</cffunction>

	<cffunction name="update" returnType="ClientBean" access="public" output="false">
		<cfargument name="cBean" type="ClientBean" required="true">

		<cfquery datasource="#variables.dsn#">
		update clients
		set	name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cBean.getName()#" maxlength="255">,
			emailaddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cBean.getEmailAddress()#" maxlength="255">,
			notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.cBean.getNotes()#">
			where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cBean.getID()#" maxlength="35">
		</cfquery>				

		<cfreturn arguments.cBean>
	</cffunction>
	
</cfcomponent>