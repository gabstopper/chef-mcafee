#
# Cookbook Name:: mcafee
# Recipe:: dpclinux
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'mcafee::eposerver'

mcafee 'agent' do
  action :install
end

mcafee 'vse' do
  action :install
end

mcafee 'dpc' do
  action :install
end

#-------------------------End of Recipe-----------------------------------


