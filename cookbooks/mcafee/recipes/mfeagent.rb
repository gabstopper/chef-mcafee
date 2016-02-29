#
# Cookbook Name:: mcafee
# Recipe:: dpclinux
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#mcafee 'vse' do
#  action :remove
#end
#mcafee 'agent' do
#  action :remove
#end

#mcafee 'agent' do
#  workdir "/tmp"
#  action :install
#end

mcafee 'vse' do
  action :remove
end

mcafee 'dpc' do
  action :remove
end

mcafee 'agent' do
  action :remove
end

#mcafee 'vse' do
#  action :install
#end

#---------------------------End of Recipe-----------------------------------


