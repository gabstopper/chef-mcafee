#
# Cookbook Name:: mcafee-linux-vse
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#Performs MA ASCI
execute 'reports_to_ePO' do
  command "sudo /opt/McAfee/cma/bin/cmdagent -P"
  action :run
end
#---------------------------End of Recipe-----------------------------------
