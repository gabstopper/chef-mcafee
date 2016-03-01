McAfee cookbook
========

This is a set of chef cookbook recipes for deployment of various McAfee endpoint software such as VirusScan, Host IPS, Host Firewall, McAfee Agent and Data Protection for Cloud.
It uses two providers to handle linux based platforms and windows based platforms. Based on the platform type, the correct provider will be used.

Repository Directories
======================

This repository contains several directories, and each directory contains a README file that describes what it is for in greater detail, and how to use it for managing your systems with Chef.

* `cookbooks/` - Sample cookbooks showing common examples
* `data_bags/` - Store data bags and items in .json in the repository.

Requirements
=============
* `windows cookbook` - https://github.com/opscode-cookbooks/windows
* `chef_handler` - https://github.com/opscode-cookbooks/chef_handler

Platforms
=============
See McAfee documentation for more information (www.mcafee.com)
* `Ubuntu` 
* `RedHat`
* `Windows`
* `Amazon Linux`
TODO: Specific versions

Next Steps
==========

Read the README file in each of the subdirectories for more information about what goes in those directories.
