<!---
	Name:			/campaign_edit.cfm
	Last Updated:	8/16/06
	History:		HTML mistake on two select tags (thanks to sneakylama) (1/22/06)
					IE fixes (rkc 8/16/06)
--->

<cfparam name="url.id" default="">
<cfif isDefined("form.return")>
	<cflocation url="campaigns.cfm" addToken="false">
</cfif>

<cfparam name="form.newadid" default="">
<cfparam name="form.newweight" default="">
<cfparam name="form.datebegin" default="">
<cfparam name="form.dateend" default="">
<cfparam name="form.timebegin" default="">
<cfparam name="form.timeend" default="">
<cfparam name="form.editadid" default="">
<cfparam name="form.editweight" default="">
<cfparam name="form.editdatebegin" default="">
<cfparam name="form.editdateend" default="">
<cfparam name="form.edittimebegin" default="">
<cfparam name="form.edittimeend" default="">

<!--- Handle the deletion of an Ad --->
<cfif url.id neq "" and isDefined("form.deletead") and isDefined("form.deletead_id") and isValid("UUID",form.deletead_id)>
	<cfset application.campaignManager.deleteAd(url.id, form.deletead_id)>
</cfif>

<!--- Handle the addition of an Ad --->
<cfif url.id neq "" and isDefined("form.newad")>
	<cfset errormsg = "">
	<cfif len(trim(form.datebegin))>	
		<cfif not isDate(form.datebegin)>
			<cfset errormsg = errormsg & "Beginning Date must be a valid date.<br">
		<cfelse>
			<!--- format date to remove any time value --->
			<cfset form.datebegin = dateFormat(form.datebegin,"mmmm d, yyyy")>
		</cfif>
	</cfif>
	<cfif len(trim(form.dateend))>	
		<cfif not isDate(form.dateend)>
			<cfset errormsg = errormsg & "End Date must be a valid date.<br">
		<cfelse>
			<!--- format date to remove any time value --->
			<cfset form.dateend = dateFormat(form.dateend,"mmmm d, yyyy")>
		</cfif>
	</cfif>
	<cfif len(trim(form.dateend)) and len(trim(form.datebegin)) and isDate(form.dateend) and isDate(form.datebegin)>
		<cfif dateCompare(form.datebegin, form.dateend) is 1>
			<cfset errormsg = errormsg & "The end date must be after the beginning date.<br>">
		</cfif>
	</cfif>
	
	<cfif len(trim(form.timebegin))>	
		<cfif not isDate(form.timebegin)>
			<cfset errormsg = errormsg & "Beginning Time must be a valid time.<br">
		<cfelse>
			<!--- format date to remove any date value --->
			<cfset form.timebegin = timeFormat(form.timebegin,"h:mm tt")>
		</cfif>
	</cfif>
	<cfif len(trim(form.timeend))>	
		<cfif not isDate(form.timeend)>
			<cfset errormsg = errormsg & "End Time must be a valid time.<br">
		<cfelse>
			<!--- format date to remove any date value --->
			<cfset form.timeend = timeFormat(form.timeend,"h:mm tt")>
		</cfif>
	</cfif>
	<cfif len(trim(form.timeend)) and len(trim(form.timebegin)) and isDate(form.timeend) and isDate(form.timebegin)>
		<cfif dateCompare(form.timebegin, form.timeend) is 1>
			<cfset errormsg = errormsg & "The end time must be after the beginning time.<br>">
		</cfif>
	</cfif>

	<cfif not len(errormsg)>
		<cftry>
		<cfinvoke component="#application.campaignManager#" method="addAd">
			<cfinvokeargument name="campaignidfk" value="#url.id#">
			<cfinvokeargument name="adidfk" value="#form.newadid#">
			<cfinvokeargument name="weight" value="#form.newweight#">
			<cfif len(trim(form.datebegin))>
				<cfinvokeargument name="datebegin" value="#form.datebegin#">
			</cfif>	
			<cfif len(trim(form.dateend))>
				<cfinvokeargument name="dateend" value="#form.dateend#">
			</cfif>	
			<cfif len(trim(form.timebegin))>
				<cfinvokeargument name="timebegin" value="#form.timebegin#">
			</cfif>	
			<cfif len(trim(form.timeend))>
				<cfinvokeargument name="timeend" value="#form.timeend#">
			</cfif>	
		</cfinvoke>
		<cfset form.newadid = "">
		<cfset form.newweight = "">
		<cfset form.datebegin = "">
		<cfset form.dateend = "">
		<cfset form.timebegin = "">
		<cfset form.timeend = "">
		<cfcatch>
			<cfset errormsg = cfcatch.message & cfcatch.detail>
		</cfcatch>
		</cftry>
	</cfif>
</cfif>

<!--- Handle the edit of an Ad --->
<cfif url.id neq "" and isDefined("form.editad") and isDefined("form.editsadid")>
	<cfset errormsg = "">
	<cfif len(trim(form.editdatebegin))>	
		<cfif not isDate(form.editdatebegin)>
			<cfset errormsg = errormsg & "Beginning Date must be a valid date.<br">
		<cfelse>
			<!--- format date to remove any time value --->
			<cfset form.editdatebegin = dateFormat(form.editdatebegin,"mmmm d, yyyy")>
		</cfif>
	</cfif>
	<cfif len(trim(form.editdateend))>	
		<cfif not isDate(form.editdateend)>
			<cfset errormsg = errormsg & "End Date must be a valid date.<br">
		<cfelse>
			<!--- format date to remove any time value --->
			<cfset form.editdateend = dateFormat(form.editdateend,"mmmm d, yyyy")>
		</cfif>
	</cfif>
	<cfif len(trim(form.editdateend)) and len(trim(form.editdatebegin)) and isDate(form.editdateend) and isDate(form.editdatebegin)>
		<cfif dateCompare(form.editdatebegin, form.editdateend) is 1>
			<cfset errormsg = errormsg & "The end date must be after the beginning date.<br>">
		</cfif>
	</cfif>
	
	<cfif len(trim(form.edittimebegin))>	
		<cfif not isDate(form.edittimebegin)>
			<cfset errormsg = errormsg & "Beginning Time must be a valid time.<br">
		<cfelse>
			<!--- format date to remove any date value --->
			<cfset form.edittimebegin = timeFormat(form.edittimebegin,"h:mm tt")>
		</cfif>
	</cfif>
	<cfif len(trim(form.edittimeend))>	
		<cfif not isDate(form.edittimeend)>
			<cfset errormsg = errormsg & "End Time must be a valid time.<br">
		<cfelse>
			<!--- format date to remove any date value --->
			<cfset form.edittimeend = timeFormat(form.edittimeend,"h:mm tt")>
		</cfif>
	</cfif>
	<cfif len(trim(form.edittimeend)) and len(trim(form.edittimebegin)) and isDate(form.edittimeend) and isDate(form.edittimebegin)>
		<cfif dateCompare(form.edittimebegin, form.edittimeend) is 1>
			<cfset errormsg = errormsg & "The end time must be after the beginning time.<br>">
		</cfif>
	</cfif>

	<cfif not len(errormsg)>
		<cftry>
		<cfinvoke component="#application.campaignManager#" method="editAd">
			<cfinvokeargument name="scheduledadid" value="#form.editsadid#">
			<cfinvokeargument name="campaignidfk" value="#url.id#">
			<cfinvokeargument name="adidfk" value="#form.editadid#">
			<cfinvokeargument name="weight" value="#form.editweight#">
			<cfif len(trim(form.editdatebegin))>
				<cfinvokeargument name="datebegin" value="#form.editdatebegin#">
			</cfif>	
			<cfif len(trim(form.editdateend))>
				<cfinvokeargument name="dateend" value="#form.editdateend#">
			</cfif>	
			<cfif len(trim(form.edittimebegin))>
				<cfinvokeargument name="timebegin" value="#form.edittimebegin#">
			</cfif>	
			<cfif len(trim(form.edittimeend))>
				<cfinvokeargument name="timeend" value="#form.edittimeend#">
			</cfif>	
		</cfinvoke>
		<cfset form.editadid = "">
		<cfset form.editweight = "">
		<cfset form.editdatebegin = "">
		<cfset form.editdateend = "">
		<cfset form.edittimebegin = "">
		<cfset form.edittimeend = "">
		<cfcatch>
			<cfset errormsg = cfcatch.message & cfcatch.detail>
		</cfcatch>
		</cftry>
	</cfif>
</cfif>

<cfif isDefined("form.save")>
	<cfset errormsg = "">
	
	<cfif not isDefined("form.active")>
		<cfset form.active = false>
	<cfelse>
		<cfset form.active = true>
	</cfif>
	
	<cfif not len(errormsg)>
		<!--- even though we may error out, go ahead and clear cache --->
		<cfif structKeyExists(application,"adcache") and structKeyExists(application.adcache, url.id)>
			<cflock name="#application.lockname#" type="exclusive" timeout="30">
				<cfset structDelete(application.adcache, url.id)>
			</cflock>
		</cfif>
		
		<cftry>
			<cfif url.id eq "">
				<cfset cBean = createObject("component","components.CampaignBean")>
				<cfset cBean.setName(form.name)>
				<cfset cBean.setActive(form.active)>
				<cfset cBean.setCreated(now())>
				<cfset cBean.setUpdated(now())>
				<cfset errors = cBean.validate()>
				<cfif arrayLen(errors) is 0>
					<cfset cBean = application.campaignDAO.create(cBean)>
					<!--- We now stay on the page so a user can ad ads --->
					<cflocation url="campaign_edit.cfm?id=#cBean.getID()#" addToken="false">
				<cfelse>
					<cfset errormsg = arrayToList(errors,"<br>")>
				</cfif>
			<cfelse>
				<cfset cBean = application.campaignDAO.read(url.id)>
				<cfif cBean.getID() neq url.id>
					<cflocation url="campaigns.cfm?msg=error:::Invaild campaign." addToken="false">
				</cfif>
				<cfset cBean.setName(form.name)>
				<cfset cBean.setActive(form.active)>
				<cfset cBean.setCreated(now())>
				<cfset cBean.setUpdated(now())>
				<cfset errors = cBean.validate()>
				<cfif arrayLen(errors) is 0>
					<cfset cBean = application.campaignDAO.update(cBean)>
					<cfset url.id = cBean.getID()>
					<cflocation url="campaigns.cfm?msg=success:::Campaign details updated successfully." addToken="false">
				<cfelse>
					<cfset errormsg = arrayToList(errors,"<br>")>
				</cfif>
			</cfif>
			<cfcatch>
				<cfset errormsg = cfcatch.message & cfcatch.detail>
			</cfcatch>
		</cftry>
	</cfif>
</cfif>

<cfif url.id neq "">
	<cfset campaign = application.campaignDAO.read(url.id)>
	<cfif url.id neq campaign.getID()>
		<cflocation url="campaigns.cfm?msg=error:::Invaild campaign." addToken="false">
	</cfif>
	<cfparam name="form.name" default="#campaign.getName()#">
	<!--- any form submission? --->
	<cfif isDefined("form.fieldnames")>
		<cfif isDefined("form.active")>
			<cfset form.active = true>
		<cfelse>
			<cfset form.active = false>
		</cfif>
	<cfelse>
		<cfparam name="form.active" default="#campaign.getActive()#">
	</cfif>
<cfelse>
	<cfparam name="form.name" default="">
	<cfparam name="form.active" default="false">
</cfif>

<cfset ads = application.adManager.getAds(true)>
<cfif url.id is not "">
	<cfset scheduledAds = application.campaignManager.getScheduledAds(url.id)>
</cfif>

<cfmodule template="tags/layout.cfm" title="#application.title# - Campaign Edit">

<cfoutput>
<h2>Campaign Edit  (<cfif form.active>Active<cfelse>NOT Active</cfif>)</h2>
</cfoutput>

<cfif ads.recordCount>

	<cfoutput>
	<cfif isDefined("errormsg") and len(errormsg)>
	<div class="alert alert-error"><b>#errormsg#</b></div>
	</cfif>
	
	<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="main" id="main">
	
	<p>
	<fieldset title="Campaign Information">
	<legend>Campaign Information</legend>
	<table>
		<tr>
			<td><label for="name">Name:</label></td>
			<td><input type="text" id="name" name="name" value="#form.name#" class="required"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><label for="active" class="checkbox"><input type="checkbox" name="active" id="active" <cfif form.active>checked</cfif> value="true"> Active</label></td>
		</tr>
	</table>
	</fieldset>
	</p>
	
	<cfif url.id neq "" and ads.recordCount>
			
	<p>
	<fieldset title="Ads">
	<legend>Ads</legend>
	<!--- used to store the id of the scheduled ad to move --->
	<!---
	To do later
	<input type="hidden" name="ad_id" value="">
	--->
	<!--- used to store the id of the scheduled ad to delete --->
	<input type="hidden" name="deletead_id" value="">
	<!--- used to store the id of the scheduled ad to update --->
	<input type="hidden" name="editsadid" value="">
	<cfif url.id is not "" and scheduledAds.recordCount>
		<script>
		function setForm(id, weight,bd,ed,bt,et,sadid) {
			var frm = document.getElementById("editad");
			document.newweight = weight;
			for(var i=0; i < document.main.editadid.options.length; i++) {
				if(document.main.editadid.options[i].value == id) document.main.editadid.options.selectedIndex = i;	
			}
			for(var i=0; i < document.main.editweight.options.length; i++) {
				if(document.main.editweight.options[i].value == weight) document.main.editweight.options.selectedIndex = i;	
			}
			document.main.editdatebegin.value = bd;
			document.main.editdateend.value = ed;
			document.main.edittimebegin.value = bt;
			document.main.edittimeend.value = et;
			document.main.editsadid.value = sadid;
			frm.style.display='inline';
		}
		</script>
		<table width="80%" class="table table-striped table-bordered table-condensed tablesorter">
			<tr>
				<td>Ad</td>
				<td>Weight</td>
				<td>Date/Time Restrictions</td>
				<td>&nbsp;</td>
			</tr>
			<cfloop query="scheduledAds">
			<tr>
				<td>#adname#</td>
				<td>#weight#</td>
				<td>
				<cfif len(datebegin)>
					#dateFormat(datebegin, "mm/dd/yy")#
					<cfset didB = true>
				</cfif>
				<cfif len(timebegin)>
					#timeFormat(timebegin, "h:mm tt")#
					<cfset didB = true>
				</cfif>
				<cfif len(datebegin) or len(timebegin) or len(dateend) or len(timeend)> - </cfif>
				<cfif len(dateend)>
					#dateFormat(dateend, "mm/dd/yy")#
				</cfif>
				<cfif len(timeend)>
					#timeFormat(timeend, "h:mm tt")#
				</cfif>
				&nbsp;</td>
				<td>
				<input type="submit" name="deletead" value="Remove" onClick="document.main.deletead_id.value='#id#'"> 
				<input type="button" name="editadbutton" onClick="setForm('#adidfk#','#weight#','#dateFormat(datebegin,"mm/dd/yy")#','#dateFormat(dateend,"mm/dd/yy")#','#timeFormat(timebegin, "h:mm tt")#','#timeFormat(timeend, "h:mm tt")#','#scheduledAds.id#');" value="Edit">
				<!---
				Will be done later.
				<input type="submit" name="moveup" value="Move Up" onClick="document.main.ad_id.value='#id#'" <cfif currentRow is 1>disabled</cfif>>
				<input type="submit" name="movedown" value="Move Down" onClick="document.main.ad_id.value='#id#'" <cfif currentRow is recordCount>disabled</cfif>>
				--->
				
				</td>
			</tr>
			</cfloop>
		</table>
	</cfif>
	</fieldset>
	</p>
	
<cfif url.id neq "" and isDefined("form.editad") and isDefined("form.editsadid") and len(errormsg)>
	<div id="editad" style="">
<cfelse>	
	<div id="editad" style="display: none;">
</cfif>
		<p>
		<fieldset title="Edit Ad">
		<legend>Edit Ad</legend>
		<table>
			<tr>
				<td>Edit Ad:</td>
				<td>
				<select name="editadid">
				<cfloop query="ads">
				<option value="#id#" <cfif form.editadid is id>selected</cfif>>#name#</option>
				</cfloop>
				</select>
				</td>
			</tr>
			<tr>
				<td>Weight:</td>
				<td>
				<select name="editweight">
				<cfloop index="x" from="1" to="10">
				<option value="#x#" <cfif form.editweight is x>selected</cfif>>#x#</option>
				</cfloop>
				</td>
			</tr>
			<tr>
				<td><label for="editdatebegin">Beginning Date:</label></td>
				<td><input type="text" name="editdatebegin" id="editdatebegin" value="#form.editdatebegin#"></td>
			</tr>
			<tr>
				<td><label for="editdateend">End Date:</label></td>
				<td><input type="text" name="editdateend" id="editdateend" value="#form.editdateend#"></td>
			</tr>
			<tr>
				<td><label for="edittimebegin">Beginning Time:</label></td>
				<td><input type="text" name="edittimebegin" id="edittimebegin" value="#form.edittimebegin#"></td>
			</tr>
			<tr>
				<td><label for="edittimeend">End Time:</label></td>
				<td><input type="text" name="edittimeend" id="edittimeend" value="#form.edittimeend#"></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><input type="submit" name="editad" value="Edit Scheduled Add"></td>
			</tr>
		</table>
		</fieldset>
		</p>
	</div>

	<p>
	<fieldset title="New Ad">
	<legend>New Ad</legend>
	<table>
		<tr>
			<td>New Ad:</td>
			<td>
			<select name="newadid">
			<cfloop query="ads">
			<option value="#id#" <cfif form.newadid is id>selected</cfif>>#name#</option>
			</cfloop>
			</select>
			</td>
		</tr>
		<tr>
			<td>Weight:</td>
			<td>
			<select name="newweight">
			<cfloop index="x" from="1" to="10">
			<option value="#x#" <cfif form.newweight is x>selected</cfif>>#x#</option>
			</cfloop>
			</td>
		</tr>
		<tr>
			<td><label for="datebegin">Beginning Date:</label></td>
			<td><input type="text" name="datebegin" id="datebegin" value="#form.datebegin#"></td>
		</tr>
		<tr>
			<td><label for="dateend">End Date:</label></td>
			<td><input type="text" name="dateend" id="dateend" value="#form.dateend#"></td>
		</tr>
		<tr>
			<td><label for="timebegin">Beginning Time:</label></td>
			<td><input type="text" name="timebegin" id="timebegin" value="#form.timebegin#"></td>
		</tr>
		<tr>
			<td><label for="timeend">End Time:</label></td>
			<td><input type="text" name="timeend" id="timeend" value="#form.timeend#"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="submit" class="btn" name="newad" value="Add Scheduled Ad"></td>
		</tr>
	</table>
	</fieldset>
	</p>
	
	<cfelse>
	
	<p>
	Note: You will be able to select ads for this campaign once you have saved it.
	</p>
	
	</cfif>
	<div class="form-actions">
	<p>
	<table>
		<tr>
			<td>&nbsp;</td>
			<td><input type="submit" class="btn" name="return" value="Return to Campaigns"> <input type="submit" class="btn btn-primary" name="save" value="Save"></td>
		</tr>
	</table>
	</p>
	</div>
	</form>
	
	
	<cfif len(url.id)>
	<p>
	<form>
	<fieldset title="Link Code">
	<legend>Link Code</legend>
	<table>
		<tr>
			<td>The following code can be pasted into a document to load this campaign:<br>
			#htmlEditFormat(application.utils.getLinkCode(campaignid=url.id))#
			</td>
		</tr>
	</table>
	</fieldset>
	</form>
	</p>
	</cfif>
	</cfoutput>

	<cfoutput><p /></cfoutput>
<cfelse>

	<cfoutput>
	<p>
	Sorry, but you cannot work with campaigns until you have created at least one ad.
	</p>
	</cfoutput>

</cfif>


</cfmodule>
