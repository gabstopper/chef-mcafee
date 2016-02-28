#
# Cookbook Name:: mcafee
# Recipe:: remove-all
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w(mcafeevseforlinux', 'dpc', 'mfecma', 'mfert').each do |packageToRemove|
  package packageToRemove do
    ignore_failure true
    action :purge
  end
end

#---------------------------End of Recipe-----------------------------------
