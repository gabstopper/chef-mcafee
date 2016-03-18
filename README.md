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
######General Attributes
`default.mcafee.url` : Default location for retrieving installation files

######Package Info Attributes
Each `name` property must have 3 associated attributes defined in order to identify where to find the product information.

For example, to define attributes for McAfee Agent in attributes/default.rb: 

`default['mcafee']['agent']['package']`  : default location for mcafee agent package

`default['mcafee']['agent']['installer']`  : name of installer from agent package

`default['mcafee']['agent']['install_key']`  : windows display name or unix package name

For Windows based McAfee Agent, VSE and DPC:

```ruby
 case node['platform_family']
 when 'windows'
 default['mcafee']['agent'] = {
   'package' => 'agentPackages.zip',
   'installer' => 'install.sh',
   'install_key' => ['MFEcma', 'MFErt']
 }
 default['mcafee']['vse'] = {
   'package' => 'VSE880LMLRP7.Zip',
   'installer' => 'SetupVSE.exe',
   'install_key' => ['McAfee VirusScan Enterprise']
 }
 default['mcafee']['dpc'] = {
   'package' => 'MDPC1.0_Deployment_Windows.zip',
   'installer' => 'MDPCAgent.msi',
   'install_key' => ['McAfee Data Protection Agent']
 }
 end
```
**Note** Settings can be overridden in the recipe but pay attention to platform type. To set these globally, define in attributes/default.rb.

####Resource/Provider
######Actions
* `:install` (default action) install software, the specific provider will manage installation when the host is windows vs linux

* `:remove` removes software, the specific provider will manage installation when the host is windows vs linux

######Properties
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

**Note**: If `url`, `cookbook_file` or `uncpath` are not specified in the recipe, the required installer packages and files will come from the attributes/default.rb. 

If `workdir` is not specified, the working directory will default to Chef::Config[:file_cache_path]. For windows: C:\chef\cache, for linux: /var/chef/cache

####Recipes
```ruby

#Platform independent
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

#Windows specific; override download url, set workdir and set product info
mcafee 'agent' do
  url s3.amazonaws.com/myrepository
  workdir "C:/tmp"
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
