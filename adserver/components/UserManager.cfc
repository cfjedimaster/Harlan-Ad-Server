<cfcomponent output="false" displayName="User Manager">

	<cfset variables.dsn = "">
	
	<cffunction name="init" access="public" returnType="UserManager" output="false">
		<cfargument name="dsn" type="string" required="true">
		
		<cfset variables.dsn = arguments.dsn>
		<cfset variables.userDAO = createObject("component","UserDAO").init(variables.dsn)>
		<cfreturn this>
	</cffunction>	

	<cffunction name="authenticate" access="public" returnType="boolean" output="false"
				hint="Authenticates a user.">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfset var auth = "">
		
		<cfquery name="auth" datasource="#variables.dsn#">
			select	username
			from	users
			where	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="50">
			and		password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#" maxlength="50">
		</cfquery>
			
		<cfreturn auth.recordCount gte 1>	
	</cffunction>

	<cffunction name="clearGroupsForUser" access="public" returnType="void" output="false"
				hint="Removes all groups for one user.">
		<cfargument name="id" type="uuid" required="true">

		<cfquery datasource="#variables.dsn#">
		delete from users_groups
		where useridfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
		
	</cffunction>
	
	<cffunction name="getGroups" access="public" returnType="query" output="false"
				hint="Gets the groups.">		
		<cfset var data = "">
		
		<cfquery name="data" datasource="#variables.dsn#">
			select 	id, name
			from	groups
		</cfquery>
		
		<cfreturn data>
	</cffunction>

	<cffunction name="getGroupsForUser" access="public" returnType="string" output="false"
				hint="Gets the groups for a user.">		
		<cfargument name="id" type="uuid" required="true">
		<cfset var data = "">
		
		<cfquery name="data" datasource="#variables.dsn#">
			select 	groups.name
			from	groups, users_groups
			where	users_groups.useridfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
			and		users_groups.groupidfk = groups.id
		</cfquery>
		
		<cfreturn valueList(data.name)>
	</cffunction>

	<cffunction name="getUserByUsername" access="public" returnType="UserBean" output="false"
				hint="Gets a user bean based on username.">		
		<cfargument name="username" type="string" required="true">
		<cfset var data = "">
		<cfset var userBean = createObject("component","UserBean")>
		
		<cfquery name="data" datasource="#variables.dsn#">
			select 	id
			from	users
			where	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="50">
		</cfquery>
		
		<cfif data.recordCount>
			<cfset userBean = variables.userDAO.read(data.id)>
		</cfif>
		
		<cfreturn userBean>
	</cffunction>
	
	<cffunction name="getUsers" access="public" returnType="query" output="false"
				hint="Gets all the users.">		
		
		<cfset var data = "">
		
		<cfquery name="data" datasource="#variables.dsn#">
			select 	id, username, emailaddress, password, name
			from	users
		</cfquery>
		
		<cfreturn data>
	</cffunction>

	<cffunction name="setGroupsForUser" access="public" returnType="void" output="false"
				hint="Sets groups for a user. Also calls clear() first.">
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="groups" type="string" required="false" default="">
		<cfset var g = "">
		
		<cfset clearGroupsForUser(arguments.id)>

		<cfloop index="g" list="#arguments.groups#">
			<cfquery datasource="#variables.dsn#">
			insert into users_groups(useridfk,groupidfk)
			values(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#g#" maxlength="35">)
			</cfquery>
		</cfloop>
			
	</cffunction>
			
</cfcomponent>