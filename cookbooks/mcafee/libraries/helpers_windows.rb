module McafeeCookbook
  module Helpers
    module Windows
      include Chef::Mixin::PowershellOut

      def pkg_exists?(pkg)
	product = registry_lookup
	if product.nil?
	  false
	else
	  Chef::Log.info(product)
	  true
	end
      end

      def registry_lookup
	Chef::Log.info "Getting product info for #{node['mcafee'][new_resource.name]['install_key'].first}"
        regquery =<<-EOF
	  $path1 = 'Registry::HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\*'
	  $path2 = 'Registry::HKLU\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\*'
	  $path3 = 'Registry::HKLM\\Software\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\*'
	  $path4 = 'Registry::HKLU\\Software\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\*'
	  $item = Get-ItemProperty -Path $path1, $path2, $path3, $path4 -ErrorAction SilentlyContinue |
	  Where-Object {$_.DisplayName -like "#{node['mcafee'][new_resource.name]['install_key'].first}" }
 	  $x = $item | measure
	  if ($x.count -gt 0) {
	    $t = 'DisplayName={0},DisplayVersion={1},UninstallString={2}' -f $item.DisplayName, $item.DisplayVersion, $item.UninstallString
	    Write-Host -NoNewLine $t
	  } else {
	    Write-Host 'false'
	  }
	EOF
	cmd = powershell_out(regquery)
	if cmd.stdout =~ /false/
	  return nil
	else
	  hash = {}
	  cmd.stdout.split(',').each do |pair|
  	    key,value = pair.split(/=/)
  	    hash[key] = value
	  end
	end
	return hash
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
          Chef::Log.info "Install hips"
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
	  package 'McAfee Agent-ignore' do
	    source "#{new_resource.workdir}/#{node['mcafee']['agent']['installer']}"
	    installer_type :custom
	    options '/remove=agent /silent'
	  end
	when 'vse'
	  #TODO consider reboot in event of reinstall
	  package 'McAfee VirusScan Enterprise' do
	    action :remove
	    installer_type :msi
	    options '/quiet'
	  end
	when 'dpc'	#CHEF-4928 - uninstall key is set to I and should be X (DPC 1.0.1)
	  uninstall_key = registry_lookup
          new_key = uninstall_key["UninstallString"].match(/({.*})/)[1]
	  powershell_script 'McAfee Data Protection Agent' do
  	    code <<-EOH
	      msiexec /x '#{new_key}' /quiet /qn
  	    EOH
	  end
	  #package 'McAfee Data Protection Agent' do
	  #  action :remove
	  #  installer_type :msi
	  #  options '/quiet'
	  #end
	end
      end
    end
  end
end
