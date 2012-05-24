<!---
	Name:			/tags/layout.cfm
	Last Updated:	06/02/05
	History: Twitter bootstrap UI applied MitrahSoft (05/24/2012)
--->

<cfparam name="attributes.title" default="">

<cfif thisTag.executionMode is "start">

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type"
content="text/html; charset=windows-1252" />
<meta name="author" content="J.Reiser" />
<title>#attributes.title#</title>

<link href="assets/css/bootstrap2.0.1.min.css" rel="stylesheet">
<link href="assets/css/bootstrap-responsive2.0.1.min.css" rel="stylesheet">

<link href="assets/css/qTip.css" rel="stylesheet">
<link href="assets/css/tableSorter.css" rel="stylesheet">

<style>
	body {
	    padding-bottom: 40px;
	    padding-top: 60px;
	}
</style>

</head>

<body>

<div class="navbar navbar-fixed-top"> 
	<div class="navbar-inner">

		<div class="container">
			<a class="brand" href="index.cfm">#application.title#</a>
			<ul class="nav pull-right">
				<li><a href="index.cfm">Home</a></li>
				<li><a href="clients.cfm">Clients</a></li>
				<li><a href="ads.cfm">Ads</a></li>
				<li><a href="campaigns.cfm">Campaigns</a></li>
				<li><a href="reports.cfm">Reports</a></li>
				<li><a href="users.cfm">Users</a></li>
				<li><a href="index.cfm?logout=1">Logout</a></li>
			</ul>
		</div> <!--- container --->
	</div>
</div>
<div class="container">	


<cfif isDefined("url.msg") and url.msg neq ''>
	<cfset url.msg = htmlEditFormat(url.msg)>
	<cfoutput>
		<div class="alert alert-#listfirst(url.msg,':::')#">
			<b>#listlast(url.msg, ':::')#</b>
			<a class="close" data-dismiss="alert">x</a>
		</div>
	</cfoutput>
</cfif>

</cfoutput>

<cfelse>

<cfoutput>

</div>

	<footer class="container">
		<p align="right">
			UI Design Powered By <a href="https://github.com/twitter/bootstrap/">Bootstrap</a>. 
			Designed by <a href="http://www.mitrahsoft.com">MitrahSoft</a>
		</p>
	</footer>

<script src="assets/js/jquery-1.7.1.min.js"></script>
<script src="assets/js/jquery.tablesorter.js"></script>
<script src="assets/js/jquery.validate-1.9.0.min.js"></script>
<script src="assets/js/jquery.validate.additional-methods-1.9.0.min.js"></script>
<script src="assets/js/jquery.qtip-2.0-Alpha.min.js"></script>
<script src="assets/js/bootstrap-2.0.1.min.js"></script>
<script src="assets/js/bootbox.min.js"></script>

	
<script type="text/javascript">		
		$(function(){			
			jQuery.validator.setDefaults({errorPlacement: function(errormsg, element){
				// Set positioning based on the elements position in the form				
				var elem = $(element),					
				corners = ['right center', 'left center'],					
				flipIt = elem.parents('span.left').length > 0;				
				// Check we have a valid error message				
				if(!errormsg.is(':empty')) {					
					// Apply the tooltip only if it isn't valid					
					elem.filter(':not(.valid)').qtip({						
					overwrite: false,						
					content: errormsg,						
					position: {							
						my: corners[ flipIt ? 0 : 1 ],							
						at: corners[ flipIt ? 1 : 0 ],							
						viewport: $(window)						
					},						
					show: {							event: false,							ready: true						},
					hide: false,						
					style: {							
					classes: 'ui-tooltip-red' 
					// Make it red... the classic error colour!						
					}					})					
					// If we have a tooltip on this element already, just update its content					
					.qtip('option', 'content.text', errormsg);				
				}				
				// If the error is empty, remove the qTip				
				else { 
					elem.qtip('destroy'); 
				}			
				},			
				success: $.noop,
				});
										
				$('form').validate();	
				$('[class^="icon-"]').tooltip();					
				setupTablesorter();		
			});	
			
						
			function setupTablesorter() {		  
			  $('table.tablesorter').each(function (i, e) {		        
				  var myHeaders = {}		        
				  $(this).find('th.nosort').each(function (i, e) {		            
				  myHeaders[$(this).index()] = { sorter: false };		        
			  });				        
			  $(this).tablesorter({ headers: myHeaders });		    });    		
			}		
			  
			  
			  
			                  		
			  function confirmDelete(url){
			  	bootbox.dialog("Are you sure want to delete this data?", [{
			  		"label": "Close",
			  		"icon": "icon-ban-circle"
			  	}, {
			  		"label": "Delete!",
			  		"class": "btn-danger",
			  		"icon": "icon-warning-sign icon-white",
			  		"callback": function(){
			  			window.location = url;
			  		}
			  	}]);
			  	
			  }						
								
	</script>


</body>
</html>
</cfoutput>

</cfif>
