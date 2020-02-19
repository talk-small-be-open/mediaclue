![logo](/main/web_root/img/logo.png)

# Web based media assets management

(German: __Mediendatenbank__)

Mediaclue is an open source digital assets management application. It is mainly targeted for schools.
Mediaclue was developed from mindclue gmbh (www.mindclue.ch) in cooperation with
Gymnasium Hohe Promenade, Zürich (www.kshp.ch).

Official website: http://www.mediaclue.ch

(This version has been rewritten from scratch from the previous Rails based application.
Ruby and Rails is cool, but hey, Smalltalk and Seaside is just, hm, you know, just feels alot better! ;-) )

# Contact, support & installation service

Andreas Brodbeck, mindclue GmbH, andreas.brodbeck@mindclue.ch

# License

GNU AGPLv3, see [LICENSE](LICENSE.md)

# Features

* HTML5
* Responsive and mobile device ready
* Very sophisticated, user friendly upload process, suitable for uploading multiple files and folders at once. Made possible through the integration of www.plupload.com.
* Suitable for many document types. Images, office documents, movies, zip packages, raw data files etc.
* Let users organize their collected media in collections. A media can be in more than one collection. You can even add media from other users to your collections (given that you have access permission to it).
* Generates previews of a number of widely used document formats: Virtually all image formats, Word, Excel, PowerPoint, OpenOffice documents, flash movies, quicktime movies, etc.
* Let user tag their media collections and media items. Has special mandatory tags for the lesson subject (school).
* Search engine, searches through tags and descriptions of collections and media.
* Lets users save their search queries, for simplifying recurring search tasks.
* Lets users download a on-the-fly packaged ZIP file, with all the documents of a collection.
* Lets users download a on-the-fly generated PDF file, for offline slideshow presentation (Images only).
* Visually sort your media in a collection with drag & drop
* Lets users order their collections on their personal overview page.
* Automatically shows a list of my collections, grouped by the most used tags.
* TBD

# Installation

TBD

* Get a fresh Linux server, e.g. Ubuntu Server, where mediaclue should be installed.
* Clone this repository and its submodules to your development machine: `git clone --recurse-submodules <URL>` .
* Get ansible on your development machine: http://ansible.com
* Choose a short code for your the mediaclue instance. For example your organization name ("tesla"), or application purpose ("media") or similar short name.
* Create a ansible vault password in a file and set it in ansible.cfg
* Put your public key(s) which should be SSH authorized in the server into the directory files/ssh/authorized_keys/
* Create a deployment inventory for ansible: Create inventory_yourname.yml file from the template file inventory_template.yml
* Create a configuration for mediaclue: Create mediaclue_yourname.yml file from the template file mediaclue_template.yml
* Use the script install.sh yourname

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

* Andreas Brodbeck (andreas.brodbeck at mindclue.ch), developer and maintainer of the project.
* Armin Frischknecht (www.hoppingmad.ch), for design stuff and the making of the official website www.mediaclue.ch and the advertising in his environment.
