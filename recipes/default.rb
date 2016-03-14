#
# Cookbook Name:: mcafee
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#workaround requiretty when sudo is run on rhel platforms

ruby_block "tmp disable requiretty" do
  block do
    sed = Chef::Util::FileEdit.new("/etc/sudoers")
    sed.search_file_replace(/^(Defaults\s+requiretty)/i, '#\1')
    sed.write_file
  end
  only_if { ::File.readlines(sudoers).grep(requiretty).any? }
end if platform_family?('rhel')
