#
# Cookbook Name:: mcafee-linux-vse
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'mcafee::eposerver'

if ( ::File.exists?( node['mcafee']['agentlinux'] ))
  Chef::Log.warn("McAfee Agent already installed, continuing on")
  return
end

package 'unzip' do
  action :install
end

mcafee = data_bag_item("mcafee-databag", "data")

#Retrieve McAfee Agent
remote_file "/tmp/agentPackages.zip" do
  source "#{mcafee['http']['http_host']}/agentPackages.zip"
  action :create_if_missing
  notifies :run, 'execute[unpack_MA]', :immediately
  notifies :run, 'execute[provide_exe_permission]', :immediately
  notifies :run, 'execute[install_mfe_agent]', :immediately
end

#Unpack mcafee agent
execute 'unpack_MA' do
  command "sudo unzip -o /tmp/agentPackages.zip"
  action :nothing
end

#Add execute to installer
execute 'provide_exe_permission' do
  command "sudo chmod a+x install.sh"
  action :nothing
end

#Install McAfee Agent
execute 'install_mfe_agent' do
  command "sudo ./install.sh -i"
  action :nothing
end

#---------------------------End of Recipe-----------------------------------
