
# Cookbook Name:: mcafee
# Recipe:: eposerver 
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

mcafee = data_bag_item("mcafee-databag", "data")

ruby_block "ensure node can resolve ePO FQDN" do
  block do
    if node['platform_family'] == 'windows'
      fe = Chef::Util::FileEdit.new("C:\\Windows\\system32\\drivers\\etc\\hosts")
    else
      fe = Chef::Util::FileEdit.new("/etc/hosts")
    end 
    fe.insert_line_if_no_match(/#{mcafee['epo_server']['fqdn']}/,
                               "#{mcafee['epo_server']['ip']} #{mcafee['epo_server']['fqdn']} #{mcafee['epo_server']['shortname']}")
    fe.write_file
  end
  not_if { Resolv.getaddress(mcafee['epo_server']['fqdn']) rescue false }
end

#---------------------------End of Recipe-----------------------------------
