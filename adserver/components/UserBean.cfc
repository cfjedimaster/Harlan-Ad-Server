<cfcomponent output="false" displayName="User Bean" hint="Manages a user.">

	<cfset variables.instance = structNew() />
	<cfset variables.instance.id = 0 />
	<cfset variables.instance.username = "" />
	<cfset variables.instance.password = "" />
	<cfset variables.instance.name = "" />	
	<cfset variables.instance.emailaddress = "" />

	<cffunction name="setID" returnType="void" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		<cfset variables.instance.id = arguments.id>
	</cffunction>

	<cffunction name="getID" returnType="string" access="public" output="false">
		<cfreturn variables.instance.id>
	</cffunction>
	
	<cffunction name="setUserName" returnType="void" access="public" output="false">
		<cfargument name="username" type="string" required="true">
		<cfset variables.instance.username = arguments.username>
	</cffunction>
	
	<cffunction name="getUserName" returnType="string" access="public" output="false">
		<cfreturn variables.instance.username>
	</cffunction>

	<cffunction name="setPassword" returnType="void" access="public" output="false">
		<cfargument name="password" type="string" required="true">
		<cfset variables.instance.password = arguments.password>
	</cffunction>
  
	<cffunction name="getPassword" returnType="string" access="public" output="false">
		<cfreturn variables.instance.password>
	</cffunction>

	<cffunction name="setName" returnType="void" access="public" output="false">
		<cfargument name="name" type="string" required="true">
		<cfset variables.instance.name = arguments.name>
	</cffunction>
  
	<cffunction name="getName" returnType="string" access="public" output="false">
		<cfreturn variables.instance.name>
	</cffunction>

	<cffunction name="setEmailAddress" returnType="void" access="public" output="false">
		<cfargument name="emailaddress" type="string" required="true">
		<cfset variables.instance.emailaddress = arguments.emailaddress>
	</cffunction>
	
	<cffunction name="getEmailAddress" returnType="string" access="public" output="false">
		<cfreturn variables.instance.emailaddress>
	</cffunction>
	
	<cffunction name="validate" returnType="array" access="public" output="false">
		<cfset var errors = arrayNew(1)>
		
		<cfif not len(trim(getUserName()))>
			<cfset arrayAppend(errors,"UserName cannot be blank.")>
		</cfif>
	
		<cfif not isValid("regex", getUserName(), "[[:alnum:]]+")>
			<cfset arrayAppend(errors,"Username can only contain alpha-numeric characters.")>
		</cfif>	  
		<cfif not len(trim(getEmailAddress())) or not isValid("email",getEmailAddress())>
			<cfset arrayAppend(errors,"Email address cannot be blank and must be a valid email address.")>
		</cfif>
		
		<cfif not len(trim(getPassword()))>
			<cfset arrayAppend(errors,"Password cannot be blank.")>
		</cfif>

		<cfif not len(trim(getName()))>
			<cfset arrayAppend(errors,"Name cannot be blank.")>
		</cfif>

		<cfreturn errors>
	</cffunction>
	
	<cffunction name="getInstance" returnType="struct" access="public" output="false">
		<cfreturn duplicate(variables.instance)>
	</cffunction>

</cfcomponent>	