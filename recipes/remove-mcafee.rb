#
# Cookbook Name:: mcafee
# Recipe:: dpclinux
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# Remove mcafee agent last

mcafee 'vse' do
  action :remove
end

mcafee 'dpc' do
  action :remove
end

case node['platform_family']
when 'rhel', 'debian'
  mcafee 'agent' do
    workdir "/tmp"
    action :remove
  end
when 'windows'
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
    action :remove
  end
end

#-------------------------End of Recipe-----------------------------------


