<cfcomponent output="false" displayName="Ad Bean" hint="Manages an Ad.">

	<cfset variables.instance = structNew() />
	<cfset variables.instance.id = 0 />
	<!--- Pointer to client owner --->
	<cfset variables.instance.clientidfk = "" />
	<!---  Name for ad --->
	<cfset variables.instance.name = "" />
	<!--- Image URL --->
	<cfset variables.instance.source = "" />
	<!--- Image height --->
	<cfset variables.instance.height = "" />
	<!--- Image width --->
	<cfset variables.instance.width = "" />
	<!--- For text ads, the title --->
	<cfset variables.instance.title = "" />
	<!--- For text ads, the body --->
	<cfset variables.instance.body = "" />
	<!--- URL of destination --->
	<cfset variables.instance.url = "" />
	<!--- Active flag --->
	<cfset variables.instance.active = "" />
	<!--- When the ad was created --->
	<cfset variables.instance.created = "" />
	<!--- When the ad was updated --->
	<cfset variables.instance.updated = "" />
	<!--- Target for URL --->
	<cfset variables.instance.target = "" />
	<!--- HTML Based Ads --->
	<cfset variables.instance.html = "" />

	<cffunction name="setID" returnType="void" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		<cfset variables.instance.id = arguments.id>
	</cffunction>

	<cffunction name="getID" returnType="string" access="public" output="false">
		<cfreturn variables.instance.id>
	</cffunction>

	<cffunction name="setClientIDFK" returnType="void" access="public" output="false">
		<cfargument name="clientidfk" type="string" required="true">
		<cfset variables.instance.clientidfk = arguments.clientidfk>
	</cffunction>
  
	<cffunction name="getClientIDFK" returnType="string" access="public" output="false">
		<cfreturn variables.instance.clientidfk>
	</cffunction>

	<cffunction name="setName" returnType="void" access="public" output="false">
		<cfargument name="name" type="string" required="true">
		<cfset variables.instance.name = arguments.name>
	</cffunction>
  
	<cffunction name="getName" returnType="string" access="public" output="false">
		<cfreturn variables.instance.name>
	</cffunction>
	
	<cffunction name="setSource" returnType="void" access="public" output="false">
		<cfargument name="source" type="string" required="true">
		<cfset variables.instance.source = arguments.source>
	</cffunction>
  
	<cffunction name="getSource" returnType="string" access="public" output="false">
		<cfreturn variables.instance.source>
	</cffunction>

	<cffunction name="setHeight" returnType="void" access="public" output="false">
		<cfargument name="height" type="string" required="true">
		<cfset variables.instance.height = arguments.height>
	</cffunction>
  
	<cffunction name="getHeight" returnType="string" access="public" output="false">
		<cfreturn variables.instance.height>
	</cffunction>

	<cffunction name="setWidth" returnType="void" access="public" output="false">
		<cfargument name="width" type="string" required="true">
		<cfset variables.instance.width = arguments.width>
	</cffunction>
  
	<cffunction name="getWidth" returnType="string" access="public" output="false">
		<cfreturn variables.instance.width>
	</cffunction>

	<cffunction name="setTitle" returnType="void" access="public" output="false">
		<cfargument name="title" type="string" required="true">
		<cfset variables.instance.title = arguments.title>
	</cffunction>
  
	<cffunction name="getTitle" returnType="string" access="public" output="false">
		<cfreturn variables.instance.title>
	</cffunction>
	
	<cffunction name="setBody" returnType="void" access="public" output="false">
		<cfargument name="body" type="string" required="true">
		<cfset variables.instance.body = arguments.body>
	</cffunction>
  
	<cffunction name="getBody" returnType="string" access="public" output="false">
		<cfreturn variables.instance.body>
	</cffunction>

	<cffunction name="setActive" returnType="void" access="public" output="false">
		<cfargument name="active" type="string" required="true">
		<cfset variables.instance.active = arguments.active>
	</cffunction>
  
	<cffunction name="getActive" returnType="string" access="public" output="false">
		<cfreturn variables.instance.active>
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

	<cffunction name="setURL" returnType="void" access="public" output="false">
		<cfargument name="url" type="string" required="true">
		<cfset variables.instance.url = arguments.url>
	</cffunction>
  
	<cffunction name="getURL" returnType="string" access="public" output="false">
		<cfreturn variables.instance.url>
	</cffunction>

	<cffunction name="setTarget" returnType="void" access="public" output="false">
		<cfargument name="target" type="string" required="true">
		<cfset variables.instance.target = arguments.target>
	</cffunction>
	
	<cffunction name="getTarget" returnType="string" access="public" output="false">
		<cfreturn variables.instance.target>
	</cffunction>
	
	<cffunction name="setHTML" returnType="void" access="public" output="false">
		<cfargument name="html" type="string" required="true">
		<cfset variables.instance.html = arguments.html>
	</cffunction>
	
	<cffunction name="getHTML" returnType="string" access="public" output="false">
		<cfreturn variables.instance.html>
	</cffunction>
	
	<cffunction name="validate" returnType="array" access="public" output="false">
		<cfset var errors = arrayNew(1)>

		<cfif not len(trim(getClientIDFK()))>
			<cfset arrayAppend(errors,"ClientIDFK cannot be blank.")>
		</cfif>

		<cfif not len(trim(getName()))>
			<cfset arrayAppend(errors,"Name cannot be blank.")>
		</cfif>

		<cfif len(getBody()) gt 255>
			<cfset arrayAppend(errors,"Body cannot be longer than 255 characters.")>
		</cfif>

		<!--- Changed my mind about requiring these...
		<cfif not len(trim(getHeight())) or not isNumeric(getHeight())>
			<cfset arrayAppend(errors,"Height cannot be blank and must be numeric.")>
		</cfif>

		<cfif not len(trim(getWidth())) or not isNumeric(getHeight())>
			<cfset arrayAppend(errors,"Width cannot be blank and must be numeric.")>
		</cfif>
		--->
		<cfif len(trim(getHeight())) and not isNumeric(getHeight())>
			<cfset arrayAppend(errors,"Height must be numeric.")>
		</cfif>

		<cfif len(trim(getWidth())) and not isNumeric(getWidth())>
			<cfset arrayAppend(errors,"Width cannot be blank and must be numeric.")>
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

		<cfif not len(trim(getURL())) or not isValid("url", getURL())>
			<cfset arrayAppend(errors,"URL cannot be blank and must be a valid url.")>
		</cfif>

		<cfif (not len(trim(getTitle())) and not len(trim(getSource()))) and not len(trim(getHTML()))>
			<cfset arrayAppend(errors,"If not using an HTML ad, either a graphic or text title must be used for an ad.")>
		</cfif>
		
		<cfreturn errors>
	</cffunction>
	
	<cffunction name="getInstance" returnType="struct" access="public" output="false">
		<cfreturn duplicate(variables.instance)>
	</cffunction>

</cfcomponent>	
