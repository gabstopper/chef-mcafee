####McAfee cookbook
This is a set of chef cookbook recipes for deployment of various McAfee endpoint software such as VirusScan, Host IPS, Host Firewall, McAfee Agent and Data Protection for Cloud.
It uses two providers to handle linux based platforms and windows based platforms. Based on the platform type, the correct provider will be used.

####Repository Directories
This repository contains several directories, and each directory contains a README file that describes what it is for in greater detail, and how to use it for managing your systems with Chef.

* `cookbooks/` -  Sample cookbooks showing common examples
* `files/default` - cookbook file for VirusScan Enterprise silent install
* `libraries` - provider definitions for windows and linux platforms  

####Requirements
* `windows cookbook` - https://github.com/opscode-cookbooks/windows
* `chef_handler` - https://github.com/opscode-cookbooks/chef_handler

####Chef
* Chef 12+

####Platforms
See McAfee documentation for more information (www.mcafee.com)
* `Ubuntu` `12.04, 14.04` 
* `RedHat`
* `CentOS` `7`
* `Windows` `2012R2`
* `Amazon`
 * `Amazon Linux AMI 2015.09.2 x86_64 HVM`
 * `RHEL-7.2_HVM_GA-20151112`
 * `ubuntu-trusty-14.04-amd64-server-20160114.5`
 * `SUSE Linux Enterprise Server 12 SP1`

####Attributes

TODO: Document attributes

####Resource/Provider
######Actions
* `:install` (default action) install software, the specific provider will manage installation when the host is windows vs linux

* `:remove` removes software, the specific provider will manage installation when the host is windows vs linux

######Parameters
* `name` name of McAfee product to install. Valid options are:
  * `agent` McAfee Agent
  * `vse`   VirusScan Enterprise
  * `dpc`   Data Protection for Cloud
  
* `workdir` where to extract installation files and store installers. If not specified, defaults to Chef cache dir

* `url` specifies the URL to retrieve the required packages to install. Package names are defined in attributes/default.rb

* `cookbook_file` retrieve installation packages from cookbook_file **TODO

* `uncpath` retrieve installation packages from uncpath **TODO

* `product_info` hash to override product specific settings, specifically:
  * `:package`  package name; i.e. myMcafeeInstaller.zip
  * `:installer`  name of installer package
  * `:install_key`  name of product, for Windows this is the name listed in Add/Remove Programs. For *nix the package name

**Note**: If `url`, `cookbook_file` or `uncpath` are not specified, the required installer packages and files will come from the attributes/default.rb. 
See 'attributes' section above for predefined attributes.

If `workdir` is not specified, the working directory will default to Chef::Config[:file_cache_path]. For windows: C:\chef\cache, for linux: /var/chef/cache

####Recipes
```ruby
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
  product_info ({
    :package => 'FramePkg.exe'
    :installer => 'FramePkg.exe'
    :install_key => ['McAfee Agent']}
  )
  action :install
end
```

######Notes
* All recipes should include the recipe for McAfee Agent: include_recipe 'mcafee::mfeagent'
* When writing removal recipes, remove the agent last due to dependencies
