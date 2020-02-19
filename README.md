![logo](/main/web_root/img/logo.png)

# Web based media assets management

(German: __Mediendatenbank__)

Mediaclue is an open source digital assets management application. It is mainly targeted for schools.
Mediaclue was developed by mindclue gmbh (www.mindclue.ch) in cooperation with
Gymnasium Hohe Promenade, Zürich (www.kshp.ch).

Official website: www.mediaclue.ch

(This version has been rewritten from scratch from the previous Rails based application.
Ruby and Rails is cool, but hey, Smalltalk and Seaside is just, hm, you know, just feels alot better! ;-) )

# Contact, support & installation service

Andreas Brodbeck, mindclue GmbH, andreas.brodbeck@mindclue.ch

# License

GNU AGPLv3, see [LICENSE](LICENSE.md)

# Demo

https://demo.mediaclue.ch

# Features

* HTML5
* Responsive and mobile device ready
* Very sophisticated, user friendly upload process, suitable for uploading multiple files and folders at once. Made possible through the integration of www.plupload.com.
* Upload files (e.g. images) directly from your mobile device
* Suitable for many document types. Images, office documents, movies, zip packages, raw data files etc. 
* Let users organize their collected media in collections. A media can be in more than one collection. You can even add media from other users to your collections (given that you have access permission to it).
* Generates previews of a number of widely used document formats: Virtually all image formats, Word, Excel, PowerPoint, OpenOffice documents, flash movies, quicktime movies, etc.
* Let user tag their media collections and media items.
* Search engine, searches through tags and descriptions of collections and media.
* Lets users save their search queries, for simplifying recurring search tasks.
* Lets users download a on-the-fly packaged ZIP file, with all the documents of a collection.
* Lets users download a on-the-fly generated PDF file, for offline slideshow presentation (Images only).
* Integrated lighttable displays and slideshows (fullscreen)
* Visually sort your media in a collection with drag & drop
* Lets users order their collections on their personal overview page.
* Automatically shows a list of my collections, grouped by the most used tags.
* Integrates with your existing LDAP identity database for user and group synchronisation and authentication.
* ... TBD

# Installation

TBD

* Choose a short code for your mediaclue instance project, without spaces. For example your organization name ("tesla"), or application purpose ("media") or similar short name.

* Get a fresh Linux server, e.g. Ubuntu Server, where mediaclue should be installed.
* Clone this repository and its submodules to your development machine: `git clone --recurse-submodules https://github.com/talk-small-be-open/mediaclue.git` .
* Install the Ansible deployment tool on your development machine: www.ansible.com
* Got into the folder deployment
* Create a deployment inventory for ansible: Create the inventory_yourname.yml file from the template file inventory_template.yml
* Create a configuration for mediaclue: Create mediaclue_yourname.yml file from the template file mediaclue_template.yml
* (Optional) If you wish to configure SSH keys
  * Create a random Ansible vault password in a file called kjewrfkjhasdfkjhw.txt (as set in ansible.cfg)
  * Use the script create_ssh_key.sh to generate a unique new SSH-keypair for the server user.
  * Put your own public key(s) which should be SSH authorized in the server into the directory files/ssh/authorized_keys/. You will be able to SSH into the machine without password.
* Use the script `install.sh yourname` to install all together

# Usage

TBD

* After installation there will be an Administrator with your sys admin email address and initial password 'me123and' followed by your short code (see above. Example "me123andtesla")
* Go to https://your.do.main/ and login as administrator
* TBD Change password of Administrator
* Go to menu "Admin" and create some users and user groups
* (Optional) LDAP integration (OpenLDAP, Active Directory, ...)
  * Update your LDAP settings in the configuration
  * Start the LDAP synchronisation manually
  * A cron job will synchronize users nightly

# Deployment updates

TBD

Once your mediaclue server is up and running, you will use these scripts:

* update.sh to simply lightweight update your source code and files, without the application itself.
* deploy.sh to do a full deployment with stopping the application, update and restart.


# Technical stuff

* Developed with Pharo Smalltalk (www.pharo.org) and the Seaside web framework (www.seaside.st)
* Autostarts an OpenOffice server instance in the background for document conversion.
* Keeps original file stored on disk. Separates generated preview files in an other folder structure. Making it easy for backing up the original files.
* As a developer you can connect to the Pharo UI using xpra (xpra.org). Get the client for your OS and attach to xpra display number 100 on the server. You need SSH access privileges for this to work.

# Credits

* Andreas Brodbeck (www.mindclue.ch), developer and maintainer of the project.
* Armin Frischknecht (www.hoppingmad.ch), for design stuff and the making of the official website and the advertising in his environment.
