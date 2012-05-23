<cfcomponent output="false" displayName="Campaign Bean" hint="Manages a Campaign.">

	<cfset variables.instance = structNew() />
	<cfset variables.instance.id = 0 />
	<cfset variables.instance.name = "" />
	<cfset variables.instance.created = "" />
	<cfset variables.instance.updated = "" />
	<cfset variables.instance.active = "" />

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
	
	<cffunction name="setCreated" returnType="void" access="public" output="false">
		<cfargument name="created" type="string" required="true">
		<cfset variables.instance.created = arguments.created>
	</cffunction>
  
	<cffunction name="getCreated" returnType="string" access="public" output="false">
		<cfreturn variables.instance.created>
	</cffunction>

	<cffunction name="setUpdated" returnType="void" access="public" output="false">
		<cfargument name="updated" type="string" required="true">
		<cfset variables.instance.updated = arguments.updated>
	</cffunction>
  
	<cffunction name="getUpdated" returnType="string" access="public" output="false">
		<cfreturn variables.instance.updated>
	</cffunction>

	<cffunction name="setActive" returnType="void" access="public" output="false">
		<cfargument name="active" type="string" required="true">
		<cfset variables.instance.active = arguments.active>
	</cffunction>
  
	<cffunction name="getActive" returnType="string" access="public" output="false">
		<cfreturn variables.instance.active>
	</cffunction>

	<cffunction name="validate" returnType="array" access="public" output="false">
		<cfset var errors = arrayNew(1)>
		
		<cfif not len(trim(getName()))>
			<cfset arrayAppend(errors,"Name cannot be blank.")>
		</cfif>

		<cfif not len(trim(getActive())) or not isBoolean(getActive())>
			<cfset arrayAppend(errors,"Active cannot be blank and must be boolean.")>
		</cfif>

		<cfif not len(trim(getCreated())) or not isDate(getCreated())>
			<cfset arrayAppend(errors,"Created cannot be blank and must be a date.")>
		</cfif>

		<cfif not len(trim(getUpdated())) or not isDate(getUpdated())>
			<cfset arrayAppend(errors,"Updated cannot be blank and must be a date.")>
		</cfif>

		<cfreturn errors>
	</cffunction>
	
	<cffunction name="getInstance" returnType="struct" access="public" output="false">
		<cfreturn duplicate(variables.instance)>
	</cffunction>

</cfcomponent>	