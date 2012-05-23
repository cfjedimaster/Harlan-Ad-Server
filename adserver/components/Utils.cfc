<cfcomponent displayName="Util" output="false"
			 hint="This is where I'll thrown in all the little utilities I need....">
			 

	<cffunction name="getLinkCode" access="public" returnType="string" output="false"
				hint="Util function to generate link code">
		<cfargument name="adid" type="uuid" required="false">
		<cfargument name="campaignid" type="uuid" required="false">
		<cfset var path = listDeleteAt(cgi.script_name, listLen(cgi.script_name,"/"), "/")>
		<cfset var myhost = cgi.server_name>
		<cfset result = "">
				
		<cfif not isDefined("arguments.adid") and not isDefined("arguments.campaignid")>
			<cfthrow message="getLinkCode needs either arguments ADID or CampaignID">
		</cfif>

		<cfsavecontent variable="result">
		<cfoutput>
		<script type="text/javascript" src="http://#myhost##path#/adserver.cfm<cfif isDefined("arguments.campaignid")>?c=#arguments.campaignid#<cfelse>?a=#arguments.adid#</cfif>"></script>
		</cfoutput>
		</cfsavecontent>
		
		<cfreturn result>
			
	</cffunction>			 
	
	<cffunction name="toQuery" access="public" returnType="query" output="false"
				hint="Used by the stats to convert the struct data to a query.">
		<cfargument name="data" type="struct" required="true">
		<cfargument name="type" type="string" required="true" hint="Either day or hour">
		<cfset var q = queryNew("")>
		<cfset var d = "">
		
		<cfif arguments.type is "day">
			<cfset queryAddColumn(q,"day","date",arrayNew(1))>
		<cfelse>
			<cfset queryAddColumn(q,"hour","integer",arrayNew(1))>
		</cfif>
		<cfset queryAddColumn(q,"data","BigInt",arrayNew(1))>
		
		<cfloop item="d" collection="#arguments.data#">
			<cfset queryAddRow(q)>
			<cfif arguments.type is "day">
				<cfset querySetCell(q,"day",dateFormat(d,"mm/dd/yy"))>
			<cfelse>
				<cfset querySetCell(q,"hour",d)>
			</cfif>
			<cfset querySetCell(q,"data", arguments.data[d])>
		</cfloop>
		
		<cfquery name="q" dbtype="query">
		select 	*
		from	q
		order by
			<cfif arguments.type is "day">
			[day] asc
			<cfelse>
			[hour] asc
			</cfif>
		</cfquery>	
		
		<cfreturn q>
		
	</cffunction>
	
</cfcomponent>