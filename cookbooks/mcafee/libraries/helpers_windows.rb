module McafeeCookbook
  module Helpers
    module Windows
      include Chef::Mixin::ShellOut

      def pkg_exists?(pkg)
	target = "#{node['mcafee'][pkg]['install_key'].first}"
	Chef::Log.info("Target: #{target}")
        case pkg
	when 'agent'
	  begin
	  registry_data_exists?(
	  "#{target}", {
	    :name => 'ProductName',
	    :type => :string,
	    :data => 'McAfee Agent' },
	    :machine )
	  rescue
	    false
	  end
	when 'vse'
	  begin
	  registry_data_exists?(
	  "#{target}", {
	    :name => 'ProductName',
	    :type => :string,
	    :data => 'McAfee VirusScan Enterprise' },
	    :machine )
	  rescue
	    false
	  end
	when 'dpc'
	  begin
	  registry_data_exists?(
	   "#{target}", {
	     :name => 'ProductName',
	     :type => :string,
	     :data => 'McAfee Data Protection Agent' },
	     :machine )
	  rescue
	    false
	  end 
	when 'hips'
	  false
	end  
      end

      def run_install
	case new_resource.name
        when 'agent'
          install_agent
        when 'vse'
          install_vse
        when 'dpc'
          install_dpc
	when 'hips'
	  #TODO
          Chef::Log.info("Install hips")
        end
      end
    
      def install_agent
	package 'McAfee Agent' do
	  source "#{new_resource.workdir}/#{node['mcafee']['agent']['package']}"
	  installer_type :custom
	  options '/install=agent /silent'
	end
      end

      def install_vse
	windows_zipfile "#{new_resource.workdir}/vse" do
	  source "#{new_resource.workdir}/#{node['mcafee']['vse']['package']}"
  	  action :unzip
	  not_if { ::File.exists?( "#{new_resource.workdir}/vse/#{node['mcafee']['vse']['installer']}") }
	end
	package 'McAfee VirusScan Enterprise' do #Need to run the exe to embed language strings into msi
	  source "#{new_resource.workdir}/vse/#{node['mcafee']['vse']['installer']}"
	  installer_type :custom
	  options '/q'	#add this option to log app install:  /l*v "c:\temp\log.txt"
	end
      end

      def install_dpc
	windows_zipfile "#{new_resource.workdir}/dpc" do
	  source "#{new_resource.workdir}/#{node['mcafee']['dpc']['package']}"
	  action :unzip
	  not_if { ::File.exists?( "#{new_resource.workdir}/dpc/#{node['mcafee']['dpc']['installer']}") }
	end
	package 'Data Protection for Cloud' do
	  source "#{new_resource.workdir}/dpc/#{node['mcafee']['dpc']['installer']}"
	  installer_type :msi
	end
      end
	
      def run_remove
	case "#{new_resource.name}"
	when 'agent'
	  package 'McAfee Agent-override' do
	    source "#{new_resource.workdir}/#{node['mcafee']['agent']['installer']}"
	    installer_type :custom
	    options '/remove=agent /silent'
	  end
	when 'vse'	#KB52648 kc.mcafee.com, this assumes vse 8.8
	  #TODO consider reboot in event of reinstall
	  package 'McAfee VirusScan Enterprise' do
	    source "#{new_resource.workdir}/vse/vse880.msi"
	    action :remove
	    installer_type :msi
	    options '/quiet'
	  end
	when 'dpc'
	  package 'McAfee Data Protection Agent' do
	    source "#{new_resource.workdir}/dpc/#{node['mcafee']['dpc']['installer']}"
	    action :remove
	    installer_type :msi
	    options '/quiet'
	  end
	end
      end
    end
  end
end
