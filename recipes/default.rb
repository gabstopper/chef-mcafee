#
# Cookbook Name:: mcafee
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#workaround requiretty when sudo is run on rhel platforms

sudoers = "/etc/sudoers"
requiretty = /^(Defaults\s+requiretty)/i

ruby_block "tmp disable requiretty" do
  block do
    sed = Chef::Util::FileEdit.new(sudoers)
    sed.search_file_replace(requiretty, '#\1')
    sed.write_file
  end
  only_if { ::File.readlines(sudoers).grep(requiretty).any? }
end if platform_family?('rhel')
