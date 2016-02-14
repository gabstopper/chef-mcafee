# Cookbook Name:: mcafee-linux-vse
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'mcafee::mfeagent'

#Already installed
if (::File.exists?( node['mcafee']['vselinux'] ))
  Chef::Log.warn("VirusScan Enterprise for Linux already installed, continuing on")
  return
end

mcafee = data_bag_item("mcafee-databag", "data")

#Retrieve VSE for Linux
remote_file "/tmp/#{mcafee['packages']['vsel_package_name']}" do
  source "#{mcafee['http']['http_host']}/#{mcafee['packages']['vsel_package_name']}"
  action :create_if_missing
end

#Copy silent install file
cookbook_file "#{ENV['HOME']}/nails.options" do
  source 'nails.options'
  mode '0644'
  action :create
end

#unzip and untar McAfee release package which has McAfee VSEL installer
execute 'unpack' do
  command "sudo tar -zxvf /tmp/#{mcafee['packages']['vsel_package_name']}"
end

#Installing VSE for linux(VSEL)
execute 'install_vse' do
  command "sudo bash /#{mcafee['packages']['vsel_installer_name']}"
end

#---------------------------End of Recipe-----------------------------------
