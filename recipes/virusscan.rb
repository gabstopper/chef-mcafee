#
# Cookbook Name:: mcafee
# Recipe:: virusscan
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'mcafee::mfeagent'

mcafee 'vse' do
  action :install
end

#-------------------------End of Recipe-----------------------------------


