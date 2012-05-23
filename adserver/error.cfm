<!---
	Name:			/error.cfm
	Last Updated:	06/02/05
	History:
--->

<cfoutput>
<h2>Error</h2>
<p>
An error has occured. The details have been emailed to the administrator. A dump of the exception may be found below.
</p>
</cfoutput>

<cfdump var="#arguments.exception#">

