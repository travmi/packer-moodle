#Moodle Packer Image

This packer configuration sets up a vagrant box that will allow you to accomplish
rapid development with Moodle. 

##Installed Packages / Platform

Build upon Centos 6.6 image

- Percona MySQL 5.5.x
- PostgreSQL 9.4
- Apache 2.2.x
- NGINX 1.6.x

##Prerequisites

- [Packer](https://www.packer.io/downloads.html)

##Getting Started

To get started follow the procedure below to begin building an image.


####Clone the repository

1. Browse to a location on your machine.
2. Clone the repository
```
# git clone https://github.com/travmi/packer-moodle.git
# cd packer-moodle
```
3. Make changes you need.
4. Build the image.
```
# packer build moodle-centos-6.5-x86_64.json
```

Vagrant boxes will be placed in the 'build' directory. 

##Configuration

###NGINX

###Apache

###MySQL

###PostgreSQL

##Contributing

Create an issue in Github, Fork and Pull request. 