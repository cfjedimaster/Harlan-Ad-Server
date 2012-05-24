<!---
	Name:			/ad_edit.cfm
	Last Updated:	1/25/06
	History:		Updated for target support (rkc 1/25/06)
--->

<cfparam name="url.id" default="">

<cfif isDefined("form.return")>
	<cflocation url="ads.cfm" addToken="false">
</cfif>

<cfif isDefined("form.save")>

	<cfif isDefined("form.active")>
		<cfset form.active = true>
	<cfelse>
		<cfset form.active = false>
	</cfif>
	
	<cfif len(form.newfile)>
		<cfset destinationdir = expandPath("images/ads")>
		<cffile action="upload" destination="#destinationdir#" nameconflict="makeunique" filefield="newfile">
		<!--- Check to see if it is a graphic. --->
		<cfset filename = cffile.serverDirectory & cffile.serverFile>
		<cfset form.source = cffile.serverFile>
	</cfif>
	
	<!--- attempt auto sniff --->
	<cfif len(form.source) and not len(form.adwidth) and not len(form.adheight)>
		<cfset fname = expandPath("./images/ads/#form.source#")>
		<cfif fileExists(fname)>
			<cftry>
				<!---
					  Code from:
					http://www.sitepoint.com/blog-post-view.php?id=168133
					Written by  David Medlock
				--->
				<cfobject type="JAVA" action="Create" name="tk" class="java.awt.Toolkit">
		 		<cfscript>
		  		img = tk.getDefaultToolkit().getImage(fname);
		  		form.adwidth = img.getWidth();
		  		form.adheight = img.getHeight();
		 		</cfscript>
		 		<cfcatch>
		 		</cfcatch>
		 	</cftry>
	 	</cfif>
	</cfif>
	
	<cftry>
	
			<!--- even though we may error out, go ahead and clear cache --->
		<cfif structKeyExists(application,"adcache")>
			<!--- This is a destructive cache update. I could write this to be more 'gentler', but
				  blowing away the entire cache is the easy way out. I think also it is ok to assume
				  that while the admin is working on his/her ads, s/he probably isn't serving any yet.
			--->
			<cflock name="#application.lockname#" type="exclusive" timeout="30">
				<cfset structDelete(application,"adcache")>
			</cflock>
		</cfif>

		<cfif url.id eq "">
			<cfset aBean = createObject("component","components.AdBean")>
			<cfset aBean.setCreated(now())>
			<cfset aBean.setUpdated(now())>
		<cfelse>
			<cfset aBean = application.adDAO.read(url.id)>
			<cfif aBean.getID() neq url.id>
				<cflocation url="ads.cfm?msg=error:::Invaild ad." addToken="false">
			</cfif>		
			<cfset aBean.setUpdated(now())>
		</cfif>
		
		<cfset aBean.setClientIDFK(form.clientidfk)>
		<cfset aBean.setName(form.name)>
		<cfset aBean.setSource(form.source)>
		<cfset aBean.setHeight(form.adheight)>
		<cfset aBean.setWidth(form.adwidth)>
		<cfset aBean.setTitle(form.title)>
		<cfset aBean.setBody(form.body)>
		<cfset aBean.setURL(form.url)>
		<cfset aBean.setActive(form.active)>
		<cfset aBean.setTarget(form.target)>
		<cfset aBean.setHTML(form.html)>

		<cfset errors = aBean.validate()>
		<cfif arrayLen(errors) is 0>
				<cfif url.id eq "">
					<cfset aBean = application.adDAO.create(aBean)>
				<cfelse>
					<cfset aBean = application.adDAO.update(aBean)>
				</cfif>
				<cflocation url="ads.cfm?msg=success:::Ad details saved successfully." addToken="false">
		<cfelse>
			<cfset errormsg = arrayToList(errors,"<br>")>
		</cfif>
		<cfcatch>
			<cfset errormsg = cfcatch.message & cfcatch.detail>
		</cfcatch>
	</cftry>
</cfif>

<cfif url.id neq "">
	<cfset ad = application.adDAO.read(url.id)>
	<cfif url.id neq ad.getID()>
		<cflocation url="ads.cfm?msg=error:::Invaild ad." addToken="false">
	</cfif>
	<cfparam name="form.clientidfk" default="#ad.getClientIDFK()#">
	<cfparam name="form.name" default="#ad.getName()#">
	<cfparam name="form.source" default="#ad.getSource()#">
	<cfparam name="form.adheight" default="#ad.getHeight()#">
	<cfparam name="form.adwidth" default="#ad.getWidth()#">
	<cfparam name="form.title" default="#ad.getTitle()#">
	<cfparam name="form.body" default="#ad.getBody()#">
	<cfparam name="form.url" default="#ad.getURL()#">
	<cfparam name="form.active" default="#ad.getActive()#">
	<cfparam name="form.target" default="#ad.getTarget()#">
	<cfparam name="form.html" default="#ad.getHTML()#">
<cfelse>
	<cfparam name="form.clientidfk" default="">
	<cfparam name="form.name" default="">
	<cfparam name="form.source" default="">
	<cfparam name="form.adheight" default="">
	<cfparam name="form.adwidth" default="">
	<cfparam name="form.title" default="">
	<cfparam name="form.body" default="">
	<cfparam name="form.url" default="">
	<cfparam name="form.active" default="false">
	<cfparam name="form.target" default="">
	<cfparam name="form.html" default="">
</cfif>

<cfset clients = application.clientManager.getClients()>

<cfdirectory name="images" directory="#expandPath('./images/ads/')#">

<cfmodule template="tags/layout.cfm" title="#application.title# - Ad Edit">

<cfoutput>
<h2>Ad Edit  (<cfif form.active>Active<cfelse>NOT Active</cfif>)</h2>
</cfoutput>

<cfif clients.recordCount>

	<cfoutput>
	<script language="JavaScript">
	function uploader() {
		var uploader = window.open('uploader.cfm','uploader','directories=yes,location=yes,menubar=yes,resizable=yes,scrollbar=yes,status=yes,titlebar=yes,toolbar=yes,width=300,height=300')
	}
	</script>
	<cfif isDefined("errormsg")>
		<div class="alert alert-error"><b>#errormsg#</b></div>
	</cfif>
	<p>
	
	<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="main" id="main" enctype="multipart/form-data">
	
	<p>
	<fieldset title="Ad Information">
	<legend>Ad Information</legend>
	<table>
		<tr>
			<td><label for="name">Name:</label></td>
			<td><input type="text" id="name" name="name" value="#form.name#" class="required"></td>
		</tr>	
		<tr>
			<td>&nbsp;</td>
			<td><label class="checkbox" for="active"><input type="checkbox" name="active" id="active" <cfif form.active>checked</cfif> value="true"> Active</label></td>
		</tr>
		<tr>
			<td><label for="clientidfk">Client:</label></td>
			<td>
				<select name="clientidfk" id="clientidfk">
				<cfloop query="clients">
				<option value="#id#" <cfif form.clientidfk is id>selected</cfif>>#name#</option>
				</cfloop>
				</select>
			</td>
		</tr>
		
		<tr>
			<td><label for="url">URL:</label></td>
			<td><input type="text" id="url" name="url" value="#form.url#" class="required url"></td>
		</tr>	
		<tr>
			<td><label for="target">Target:</label></td>
			<td><input type="text" id="target" name="target" value="#form.target#"></td>
		</tr>	
		<tr>
			<td><label for="adwidth"><nobr>Dimensions (WxH):</nobr></label></td>
			<td><input type="text" id="adwidth" name="adwidth" value="#form.adwidth#" class="span1 number">x<input type="text" id="adheight" name="adheight" value="#form.adheight#" class="span1 number"></td>
		</tr>	
		<tr>
			<td>&nbsp;</td>
			<td><b>Note:</b> For graphical ads, the height and width will be automatically set if the values above are blank. For text-based ads, these attributes determine the height and width of the table.</td>
		</tr>	
	</table>
	</fieldset>
	</p>
	
	<script language="JavaScript">
	function updatePreview(dropdown) {
		var newimage = dropdown.options[dropdown.selectedIndex].value;
		var doc = document.getElementById("preview");
		if(doc!=null) {
			doc.innerHTML = '<img src="images/ads/'+newimage+'">';
		}
	}
	</script>
	<p>
	<fieldset title="Graphical Ad">
	<legend>Graphical Ad</legend>
	<table>
		<tr>
			<td><label for="source">Image:</label></td>
			<td>
			<select name="source" id="source" onChange="updatePreview(this)">
			<option value="" <cfif form.source is "">selected</cfif>>-- Select an Image --</option>
			<cfloop query="images">
			<cfif type is "file">
			<option value="#name#" <cfif form.source is name>selected</cfif>>#name#</option>
			</cfif>
			</cfloop>
			</select>
			</td>
		</tr>
		<tr>
			<td colspan="2">
			<!--- Preview Area --->
			<div id="preview">
			<cfif form.source is not "">
			<img src="images/ads/#form.source#">
			</cfif>
			</div>
			</td>
		</tr>
		<tr>
			<td><label for="newfile">Upload:</label></td>
			<td><input type="file" id="title" name="newfile" value=""></td>
		</tr>
	</table>
	</fieldset>
	</p>
	
	<p>
	<fieldset title="Text Ad">
	<legend>Text Ad</legend>
	<table>
		<tr>
			<td><label for="title">Title:</label></td>
			<td><input type="text" id="title" name="title" value="#form.title#"></td>
		</tr>
		<tr>
			<td colspan="2">
			<label for="body">Body:</label>
			<textarea name="body" id="body" cols="50" rows="5">#form.body#</textarea>
			</td>
		</tr>
	</table>
	</fieldset>
	</p>

	<p>
	<fieldset title="HTML Ad">
	<legend>HTML Ad</legend>
	HTML ads are ads that Harlan will not format in any way. You are responsible for ensuring it links to the proper location.
	Currently there is no clickthrough reports for these ads.
	<table>
		<tr>
			<td colspan="2">
			<label for="body">HTML:</label>
			<textarea name="html" id="html" cols="50" rows="5">#form.html#</textarea>
			</td>
		</tr>
	</table>
	</fieldset>
	</p>
	<p>
	<div class="form-actions">
	<input type="submit" class="btn" name="return" value="Return to Ads">
	<input type="submit" class="btn btn-primary" name="save" value="Save">
	</div>
	</p>
	</form>
	
	
	<cfif len(url.id)>
	<p>
	<form>
	<fieldset title="Link Code">
	<legend>Link Code</legend>
	<table>
		<tr>
			<td>The following code can be pasted into a document to load <b>only</b> this ad:<br>
			#htmlEditFormat(application.utils.getLinkCode(adid=url.id))#
			</td>
		</tr>
	</table>
	</fieldset>
	</form>
	</p>
	</cfif>
	
	</cfoutput>

<cfelse>

	<cfoutput>
	<p>
	Sorry, but you cannot work with ads until you have created at least one client.
	</p>
	</cfoutput>

</cfif>

</cfmodule>
