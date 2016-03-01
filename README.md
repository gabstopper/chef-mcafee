####McAfee cookbook
This is a set of chef cookbook recipes for deployment of various McAfee endpoint software such as VirusScan, Host IPS, Host Firewall, McAfee Agent and Data Protection for Cloud.
It uses two providers to handle linux based platforms and windows based platforms. Based on the platform type, the correct provider will be used.

####Repository Directories
This repository contains several directories, and each directory contains a README file that describes what it is for in greater detail, and how to use it for managing your systems with Chef.

* `cookbooks/` - Sample cookbooks showing common examples
* `data_bags/` - Store data bags and items in .json in the repository.

####Requirements
* `windows cookbook` - https://github.com/opscode-cookbooks/windows
* `chef_handler` - https://github.com/opscode-cookbooks/chef_handler

####Platforms
See McAfee documentation for more information (www.mcafee.com)
* `Ubuntu` 
* `RedHat`
* `Windows`
* `Amazon Linux`

TODO: Specific versions

####Recipes
```
mcafee 'agent' do
  action :install
end
mcafee 'vse' do
  action :install
end
mcafee 'dpc' do
  action :install
end

mcafee 'dpc' do
  action :remove
end

mcafee 'agent' do
  url s3.amazonaws.com/myrepository
  workdir "/tmp"
  action :install
end
```
####Attributes

TODO: Document attributes

####Resources

######Actions
* `:install` (default action) install software, the specific provider will manage installation when the host is windows vs linux

* `:remove` removes software, the specific provider will manage installation when the host is windows vs linux

TODO: Document attributes

######Parameters
* `workdir` where to extract installation files and store installers. If not specified, defaults to Chef cache dir

* `url` specifies the URL to retrieve the required packages to install. Package names are defined in attributes/default.rb

* `cookbook_file` retrieve installation packages from cookbook_file **TODO

* `uncpath` retrieve installation packages from uncpath **TODO

Note: If url/cookbook_file or uncpath is not specified, the download and working directory will default to Chef::Config[:file_cache_path]. For windows: C:\chef\cache, for linux: /var/chef/cache

