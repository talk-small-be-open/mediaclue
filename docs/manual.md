# mediaclue Manual

(TBD)

* After installation there will be an Administrator with your sysadmin email address and initial password 'me123and' followed by your short code (Example "me123andmdb")
* Go to http<span></span>://your.do.<span></span>main/ and login as administrator
* Go to menu "Admin" and create some users and user groups
* Note: Uploading files is only permitted to users, who are in a group which has the flag "Allow uploads" set. Other users can just search for media and create their personal collections.
* (Optional) LDAP integration (OpenLDAP, Active Directory, ...)
  * Update your LDAP settings in the configuration
  * Start the LDAP synchronisation manually
  * A cron job will synchronize users nightly
