class Chef
  class Provider::McafeeWindows < Chef::Provider::LWRPBase
    include McafeeCookbook::Helpers
    include Chef::Mixin::PowershellOut

    provides :mcafee, os: 'windows'
    use_inline_resources

    def whyrun_supported?
      true
    end

    action :install do
      if pkg_exists?
	Chef::Log.info "Application '#{new_resource.name}' already installed"
      else
        converge_by("Converging Windows platform") do
	  download_pkgs
	  run_install
        end
      end
    end

    action :remove do
      if pkg_exists?
        run_remove
      else
	Chef::Log.info "Application '#{new_resource.name}' is not installed, cannot be removed"
      end
    end

    def load_current_resource
      @current_resource ||= Resource::Mcafee.new(new_resource.name)
      unless ::File.exists?(new_resource.workdir)
        new_resource.workdir = Chef::Config[:file_cache_path]
      end
      #@current_resource.workdir = @new_resource.workdir
      current_resource.workdir(new_resource.workdir)
      
      if attributes_missing?
	attributes_from_node
      end

      #@current_resource	
      current_resource	
    end 

    def pkg_exists?
      Chef::Log.info "Checking for package: #{new_resource.product_info[:install_key].first}"
      is_package_installed?(new_resource.product_info[:install_key].first)
    end

    def run_install
      case new_resource.name
      when 'agent'
        package 'McAfee Agent' do
	  source full_pkg_path
          installer_type :custom
          options '/install=agent /silent'
        end
      when 'vse'
        windows_zipfile "#{new_resource.workdir}/vse" do
	  source full_pkg_path
          action :unzip
          not_if { ::File.exists?( full_installer_path('vse') )}
        end
        package 'McAfee VirusScan Enterprise' do #Need to run the exe to embed language strings into msi
          source full_installer_path('vse')
          installer_type :custom
          options '/q'  #add this option to log app install:  /l*v "c:\temp\log.txt"
        end
      when 'dpc'
        windows_zipfile "#{new_resource.workdir}/dpc" do
          source full_pkg_path
          action :unzip
          not_if { ::File.exists?( full_installer_path('dpc') )}
        end
        package 'Data Protection for Cloud' do
	  source full_installer_path('dpc')
          installer_type :msi
        end
      end
    end

    def run_remove
      case new_resource.name
      when 'agent'
        package 'McAfee Agent-ignore' do
          source full_installer_path
          installer_type :custom
          options '/remove=agent /silent'
        end
      when 'vse'
        package 'McAfee VirusScan Enterprise' do
          action :remove
          installer_type :msi
          options '/quiet'
        end
      when 'dpc'      #CHEF-4928 - uninstall key is set to I and should be X (DPC 1.0.1)
        pkg = new_resource.product_info[:install_key].first
        modified_str = installed_packages[pkg][:uninstall_string].match(/({.*})/)[1] #tmp kludge
        powershell_script 'McAfee Data Protection Agent' do
          code <<-EOH
            msiexec /x '#{modified_str}' /quiet /qn
          EOH
        end
      end
    end
  end
end

Chef::Provider.send(:include, Windows::Helper)

