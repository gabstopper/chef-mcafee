#
# Cookbook Name:: mcafee
# Recipe:: remove-mcafee
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# Remove mcafee agent last, can use delayed execution in recipe

mcafee 'vse' do
  action :remove
end

mcafee 'dpc' do
  action :remove
end

mcafee 'agent' do
  action :remove
end

#-------------------------End of Recipe-----------------------------------


