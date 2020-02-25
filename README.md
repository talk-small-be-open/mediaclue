![logo](/main/web_root/img/logo.png)

# Web based media assets management

(German: __Mediendatenbank__)

Mediaclue is an open source digital assets management application. It is mainly targeted for schools.
Mediaclue was developed by mindclue gmbh (www.mindclue.ch) in cooperation with
Gymnasium Hohe Promenade, Zürich (www.kshp.ch).

Official website: www.mediaclue.ch

_Happily developed with Pharo Smalltalk (www.pharo.org) and the Seaside web framework (www.seaside.st)!_

(This version has been rewritten from scratch from the previous Rails based application.
Ruby and Rails is cool, but hey, Smalltalk and Seaside is just, hm, you know, just feels alot better! ;-) )

# Contact & support

Andreas Brodbeck, mindclue GmbH, andreas.brodbeck@mindclue.ch

# License

GNU AGPLv3, see [LICENSE](LICENSE.md)

# Demo

https://demo.mediaclue.ch

To prevent this demo server from being hit by stupid crawlers and other stupid stupids, you need to use a password:

User: betatester
PW: beta

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

1. Choose a __short code__ for your mediaclue instance project, without spaces. For example your organization name ("tesla"), or application purpose ("media") or similar short name.
1. __Clone__ this repository to your working machine: `git clone https://github.com/talk-small-be-open/mediaclue.git`.
1. Get a fresh __Linux server__, e.g. Ubuntu Server, where mediaclue should be installed to (Bare metal, cloud, VM, whereever. If you have no clue, use this: [multipass](https://multipass.run) ). Keep the basic installation pure minimal, we just need a normal user to login via SSH shell.
1. Make sure this server is network reachable by its own __hostname__. (Poor man solution: Register the IP into your hosts file. [See Howto ...](https://support.rackspace.com/how-to/modify-your-hosts-file/) )
1. Confirm that you can __connect using SSH__ to the server as the normal user. If necessary, add your public SSH key to the authorized_keys file on the server.
1. Install the __Ansible__ deployment tool on your working machine: [github.com/ansible](https://github.com/ansible/ansible), [installation guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
1. Take your shell and go into the folder `mediaclue/deployment`
1. Create a deployment __inventory__ for ansible: Create the `inventory_yoursitename.yml` file as copy from the template file `inventory_template.yml`. Basically all you have to do is to overwrite with your servers hostname.
1. Create a __configuration__ for mediaclue: Create `mediaclue_yoursitename.yml` file as copy from the template file `mediaclue_template.yml`. Follow the comments in that file and enter your own basic settings.
1. (Optional) If you wish to configure SSH keys of the server
  * Create a random Ansible vault password in a file called `kjewrfkjhasdfkjhw.txt` (As used in ansible.cfg). That file could be named anyhow, but I choose to obfuscate the meaning ;-)
  * Use the script `create_ssh_key.sh` to generate a unique new SSH-keypair for the server user. The private key will not be stored as a file, but will be displayed to you for copy/pasting into the `mediaclue_yoursitename.yml` file.
1. (Optional) Put your own SSH public key(s) into the directory files/ssh/authorized_keys/. You will be able to SSH into the mediaclue server without password.
1. Use the script `install.sh yoursitename` to __install all together__. You will be asked by Ansible for the "BECOME password" (aka sudo), then enter the SSH users password. This will configure the Linux server, loads packages, loads Pharo, loads code into pharo und will run a frontend webserver.
1. This will take a while (around 10 minutes), then:
1. You're __done!__ You can access your mediaclue instance with http(s)<span></span>://your.do.<span></span>main/

## Troubleshooting

* You can rerun the install procedure many times, if it interrupts at one point, and you have to fix something. Only the needed tasks will be redone by Ansible.

# Usage

(TBD)

* After installation there will be an Administrator with your sysadmin email address and initial password 'me123and' followed by your short code (see above. Example "me123andtesla")
* Go to http<span></span>://your.do.<span></span>main/ and login as administrator
* Go to menu "Admin" and create some users and user groups
* Note: Uploading files is only permitted to users, who are in a group which has the flag "Allow uploads" set. Other users can just search for media and create their personal collections.
* (Optional) LDAP integration (OpenLDAP, Active Directory, ...)
  * Update your LDAP settings in the configuration
  * Start the LDAP synchronisation manually
  * A cron job will synchronize users nightly

# Deployment updates

(TBD)

Once your mediaclue server is up and running, you will use these scripts:

* `update.sh yoursitename` to simply lightweight update your source code and files, without the application itself.
* `deploy.sh yoursitename` to do a full deployment with stopping the application, update and restart.


# Technical stuff

* Developed with Pharo Smalltalk (www.pharo.org) and the Seaside web framework (www.seaside.st)
* Autostarts an OpenOffice server instance in the background for document conversion.
* Keeps original file stored on disk. Separates generated preview files in an other folder structure. Making it easy for backing up the original files.
* As a developer you can connect to the Pharo UI using xpra (xpra.org). Get the client for your OS and attach to xpra display number 100 on the server. You need SSH access privileges for this to work.

# Credits

* Andreas Brodbeck (www.mindclue.ch), developer and maintainer of the project.
* Armin Frischknecht (www.hoppingmad.ch), for design stuff and the making of the official website and the advertising in his environment.
