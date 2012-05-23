LICENSE 
Copyright 2006-2011 Raymond Camden

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
   
   
If you find this application worthy, I have a Amazon wish list set up (www.amazon.com/o/registry/2TCL1D08EZEYE ). Gifts are always welcome. ;)
Install directions may be found in harlan.doc/pdf.

Last Updated: October 25, 2011 (Version 2)
Most files updates to remove Flash Forms. 

Last Updated: September 9, 2009 (Version 1.0.6)
Both ad_edit.cfm and campaign_edit.cfm modified to make it more obvious when an object is not Active.
/Application.cfc - disable debugging.
/index.cfm - update to link
adserver.cfm had critical fixes for high load. BIG thanks go to Iain Lowe and Alicia Miller.


Last Updated: May 28, 2007 (Version 1.0.5)
/campaigns.cfm - Support for resetting campaign stats
/components/CampaignManager.cfc - same as above
/ads.cfm - Support for resetting ad stats
/components/AdManager.cfc - ditto above

Docs updated to mention special note for MySQL users.

Last Updated: April 20, 2007 (Version 1.0.4)
/components/AdBean.cfc, AdDAO.cfc - support for html ads
/ad_edit.cfm - ditto
/adserver.cfm - ditto
/campaign_edit.cfm - Ignore this for now.
/install - All db files updated.

Last Updated: January, 2007 (Version 1.0.3)
/adserver/adserver.cfm - fix to prevent inactive ads from showing.

Last Updated: August 16, 2006 (Version 1.0.2)
/adserver/components/CampainManager.cfc - don't nuke all stats when removing one ad from campaign
/adserver/campaign_edit.cfm - IE fixes 
/adserver/login.cfm - focus on load

Last Updated: January 25, 2006 (Version 1.0.1.101)
/adserver/adserver.cfm - Oops. Forgot to support remote hosts by including host name in the link URL. Thanks to Critter for alerting me on this bug.
/install/sqlserver.sql - I forgot to paste in the lines that inserted the default data, again, thanks Critter

Last Updated: January 25, 2006 (Version 1.0.1)
/install/sqlserver.sql - added the new column, target, to ads
/install/adserver.mdb - ditto
/install/mysql.sql - ditto + other fixes
/install/harlan.doc(and pdf) updated to mention Target feature
/adserver/components/adbean.cfc and addao.cfc updated to allow support for Target
/adserver/ad_edit.cfm - ditto above
/adserver/adserver.cfm - support for target + html fix
/adserver/application.cfc - error email said lighthouse pro
/adserver/campaign_edit.cfm - two html mistake (both of the above fixes from sneakylama)
	
Last Updated: January 21, 2006
First initial release. Doc and readme.txt file added.
