
# Cookbook Name:: mcafee
# Recipe:: eposerver 
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

# Once McAfee software is installed on the endpoint, it will attempt to communicate with the
# McAfee epo server agent handler (there are some exceptions but this is a general rule).
# If you are running hosts on cloud instances like AWS and do not have VPN connectivity to the ePO
# server, you may need to have a host entry in order to resolve what might be an internal hostname/fqdn.
# Check your ePO server for the configured hostname. By default, the agent software will attempt to first
# communicate with the Agent Handler by IP address, hostname, then netbios name.
# A recommended configuration when the ePO server is hosted behind a NAT device on a private network is to
# configure a dedicated Agent Handler to manage connections from remote hosts (although not required as long
# as there is connectivity to the default agent handler on the ePO server host)
 
# This recipe will add the host entry into the node platform host file so the agent handler can be resolved.
# Configure the mcafee.epo.agenthndlr attribute in the attributes/default.rb
# If this is a remotely connecting client (i.e. over the internet) use the publicly reolvable IP and/or fqdn 
# and the hostname in the same mapping. For example:
# mcafee.epo.agenthndlr.fqdn = www.lepages.net
# mcafee.epo.agenthndlr.ip = xx.xx.xx.xx 
#
# If the ePO server configured can be resolved, nothing is created on the endpoint

mcafee = node['mcafee']['epo']['agenthndlr']

ruby_block "ensure node can resolve ePO FQDN" do
  block do
    if node['platform_family'] == 'windows'
      fe = Chef::Util::FileEdit.new("C:\\Windows\\system32\\drivers\\etc\\hosts")
    else
      fe = Chef::Util::FileEdit.new("/etc/hosts")
    end 
    fe.insert_line_if_no_match(/#{mcafee['fqdn']}/,
                               "#{mcafee['ip']} #{mcafee['fqdn']} #{mcafee['shortname']}")
    fe.write_file
    Chef::Log.info "Added host entry for ePO Agent Handler into host file"
  end
  not_if { Resolv.getaddress(mcafee['fqdn']) rescue false }
end

#---------------------------End of Recipe-----------------------------------
