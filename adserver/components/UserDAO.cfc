<cfcomponent output="false" displayName="User DAO" hint="Does DAO for User">

	<cfset variables.dsn = "">
	<cfset variables.lockname = "AdServer_UserDAO">
	
	<cffunction name="init" access="public" returnType="UserDAO" output="false">
		<cfargument name="dsn" type="string" required="true">
		
		<cfset variables.dsn = arguments.dsn>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="create" access="public" returnType="UserBean" output="false">
		<cfargument name="uBean" type="UserBean" required="true">
		<cfset var insRec = "">
		<cfset var newID = createUUID()>
		<cfset var checkDupe = "">
		
		<cflock name="#variables.lockname#" type="exclusive" timeout="30">
			<cfquery name="checkDupe" datasource="#variables.dsn#">
				select 	username
				from	users
				where	username = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uBean.getUserName()#" maxlength="50">
			</cfquery>
			
			<cfif checkDupe.recordCount>
				<cfthrow type="UserDAO.DuplicateUser" message="Cannot insert two users with the same username.">
			</cfif>
			
			<cfquery name="insRec" datasource="#variables.dsn#">
				insert into users(id,username,emailaddress,password,name)
				values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#newid#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uBean.getUserName()#" maxlength="50">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uBean.getEmailAddress()#" maxlength="50">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uBean.getPassword()#" maxlength="50">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uBean.getName()#" maxlength="50">
					)
			</cfquery>
			
			<cfset uBean.setID(newid)>
		</cflock>
		
		<cfreturn uBean>
	</cffunction>
	
	<cffunction name="delete" access="public" returnType="void" output="false">
		<cfargument name="id" type="uuid" required="true">

		<cfquery datasource="#variables.dsn#">
		delete from users
		where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
			
		<!--- clean up groups --->
		<cfquery datasource="#variables.dsn#">
		delete from users_groups
		where useridfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
					
	</cffunction>
	
	<cffunction name="read" access="public" returnType="UserBean" output="false">
		<cfargument name="id" type="uuid" required="true">
		<cfset var uBean = createObject("component","UserBean")>
		<cfset var getit = "">
		
		<cfquery name="getit" datasource="#variables.dsn#">
			select 	id, username, emailaddress, password, name
			from	users
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
		
		<cfif getit.recordCount>
			<cfset uBean.setID(getit.id)>
			<cfset uBean.setUserName(getit.username)>
			<cfset uBean.setEmailAddress(getit.emailaddress)>
			<cfset uBean.setPassword(getit.password)>
			<cfset uBean.setName(getit.name)>
		</cfif>
		
		<cfreturn uBean>
	</cffunction>

	<cffunction name="update" returnType="UserBean" access="public" output="false">
		<cfargument name="UserBean" type="UserBean" required="true">
		<cfset var checkDupe = "">
		
		<cflock name="#lockname#" type="exclusive" timeout="30">
			<cfquery name="checkDupe" datasource="#variables.dsn#">
				select 	username
				from	users
				where	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.UserBean.getUserName()#" maxlength="50">
				and		id <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.UserBean.getID()#" maxlength="35">
			</cfquery>
			
			<cfif checkDupe.recordCount>
				<cfthrow type="UserDAO.DuplicateUser" message="Cannot insert two users with the same username.">
			</cfif>

			<cfquery datasource="#variables.dsn#">
			update users
			set username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.UserBean.getUserName()#" maxlength="50">,
			emailaddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.UserBean.getEmailAddress()#" maxlength="50">,
			password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.UserBean.getPassword()#" maxlength="50">,
			name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.UserBean.getName()#" maxlength="50">
			where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.UserBean.getID()#" maxlength="35">
			</cfquery>
		
		</cflock>
		<cfreturn arguments.UserBean>
	</cffunction>
	
</cfcomponent>