#
# Cookbook Name:: mcafee
# Recipe:: dpclinux
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

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


