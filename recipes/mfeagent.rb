#
# Cookbook Name:: mcafee
# Recipe:: dpclinux
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
when 'rhel', 'debian', 'suse'
  mcafee 'agent' do
    workdir "tmp"
    product_info ({
	:package => 'agentPackages.zip',
	:installer => 'install.sh',
	:install_key => ['MFEcma']}
    )
    action :install
  end
when 'windows'
  mcafee 'agent' do
    product_info ({
      :package => 'FramePkg.exe',
      :installer => 'FramePkg.exe',
      :install_key => ['McAfee Agent']}
    )
    action :install
  end
end

#-------------------------End of Recipe-----------------------------------


