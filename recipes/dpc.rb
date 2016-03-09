#
# Cookbook Name:: mcafee
# Recipe:: dpc - Data Protection for Cloud
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'mcafee::mfeagent'

mcafee 'dpc' do
  action :install
end

#-------------------------End of Recipe-----------------------------------


