#
# Cookbook Name:: mcafee
# Recipe:: dpclinux
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# Remove mcafee agent last

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
  action :nothing
end

mcafee 'vse' do
  action :remove
end

mcafee 'dpc' do
  action :remove
  notifies :remove, 'mcafee[agent]', :immediately
end

#-------------------------End of Recipe-----------------------------------


