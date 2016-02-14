#
# Cookbook Name:: mcafee-linux-vse
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'mcafee::mfeagent'

if (::File.exists?( node['mcafee']['dpclinux'] ))
  Chef::Log.warn("DPC Agent already installed, continuing on")
  return
end

mcafee = data_bag_item("mcafee-databag", "data")

#Retrieve required files
remote_file "/tmp/#{mcafee['packages']['dpc_linux_installer']}" do
  source "#{mcafee['http']['http_host']}/#{mcafee['packages']['dpc_linux_installer']}"
  action :create_if_missing
end

#unzip and untar McAfee release package which has McAfee VSEL installer
execute "sudo unzip -o /tmp/#{mcafee['packages']['dpc_linux_installer']}"

#Installing Data Proteection for Cloud
execute "sudo chmod a+x install.sh"

#Install DPC
execute "sudo bash install.sh -i"

#---------------------------End of Recipe-----------------------------------
