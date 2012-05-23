<cfcomponent output="false" displayName="Client Bean" hint="Manages a Client.">

	<cfset variables.instance = structNew() />
	<cfset variables.instance.id = 0 />
	<cfset variables.instance.name = "" />
	<cfset variables.instance.emailaddress = "" />
	<cfset variables.instance.notes = "" />
	
	<cffunction name="setID" returnType="void" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		<cfset variables.instance.id = arguments.id>
	</cffunction>

	<cffunction name="getID" returnType="string" access="public" output="false">
		<cfreturn variables.instance.id>
	</cffunction>
	
	<cffunction name="setName" returnType="void" access="public" output="false">
		<cfargument name="name" type="string" required="true">
		<cfset variables.instance.name = arguments.name>
	</cffunction>
  
	<cffunction name="getName" returnType="string" access="public" output="false">
		<cfreturn variables.instance.name>
	</cffunction>
		
	<cffunction name="setNotes" returnType="void" access="public" output="false">
		<cfargument name="notes" type="string" required="true">
		<cfset variables.instance.notes = arguments.notes>
	</cffunction>
  
	<cffunction name="getNotes" returnType="string" access="public" output="false">
		<cfreturn variables.instance.notes>
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

		<cfif not len(trim(getName()))>
			<cfset arrayAppend(errors,"Name cannot be blank.")>
		</cfif>

		<cfif not len(trim(getEmailAddress())) or not isValid("email", getEmailAddress())>
			<cfset arrayAppend(errors,"Email address cannot be blank and must be a valid email address.")>
		</cfif>

		<cfreturn errors>
	</cffunction>
	
	<cffunction name="getInstance" returnType="struct" access="public" output="false">
		<cfreturn duplicate(variables.instance)>
	</cffunction>

</cfcomponent>	
