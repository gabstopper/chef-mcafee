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
  workdir "/tmp"
  product_info ({
    :package => 'FramePkg.exe',
    :installer => 'FramePkg.exe',
    :install_key => %w(McAfee\ Agent)}
  )
  #url s3.amazon.com
  #cookbook_file blah
  #uncpath \\share
  action :install
end

mcafee 'vse' do
  action :install
end

mcafee 'dpc' do
  action :install
end

#-------------------------End of Recipe-----------------------------------


