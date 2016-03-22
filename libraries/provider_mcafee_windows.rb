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
	converge_by("Removing on Windows platform") do
          run_remove
	end
      else
	Chef::Log.info "Application '#{new_resource.name}' is not installed, cannot be removed"
      end
    end

    def load_current_resource
      @current_resource ||= Resource::Mcafee.new(new_resource.name)
      unless ::File.exists?(new_resource.workdir)
        new_resource.workdir = Chef::Config[:file_cache_path]
      end
      
      load_product_info

      current_resource	
    end 

    def pkg_exists?
      target = new_resource.product_info[:install_key].first
      is_package_installed?(target) #call windows cookbook function
    end

    def run_install
      derived_installpath = full_installer_path
      if ::File.extname(new_resource.product_info[:package]) =~ /\.(zip)$/i #If zipped, extract to product name dir
	unzip_to_directory
	derived_installpath = full_installer_path(new_resource.name)
      end
      case new_resource.name
      when 'agent'
        package 'McAfee Agent' do
	  source derived_installpath
          installer_type :custom
          options '/install=agent /silent'
        end
      when 'vse'
        package 'McAfee VirusScan Enterprise' do #Need to run the exe to embed language strings into msi
          source derived_installpath
          installer_type :custom
          options '/q'  #add this option to log app install:  /l*v "c:\temp\log.txt"
        end
      when 'dpc'
        package 'Data Protection for Cloud' do
	  source derived_installpath
          installer_type :msi
        end
      end
    end

    def run_remove
      case new_resource.name
      when 'agent'
	if exe_installer.nil? #agent should be removed from installer source
	  Chef::Log.warn "Could not find installer: #{new_resource.product_info[:installer]}, skipping removal"
        else
          package 'McAfee Agent-ignore' do
            source full_installer_path #use installer to remove
            installer_type :custom
            options '/remove=agent /silent'
          end
	end
      when 'vse'
        package 'McAfee VirusScan Enterprise' do
          action :remove
          installer_type :msi
          options '/quiet'
        end
      when 'dpc'      #CHEF-4928 - uninstall key is set to I and should be X (DPC 1.0.1)
        pkg = new_resource.product_info[:install_key].first
        modified_str = installed_packages[pkg][:uninstall_string].match(/({.*})/)[1] #tmp kludge, should check any uninstall key that uses msiexec
        powershell_script 'McAfee Data Protection Agent' do
          code <<-EOH
            msiexec /x '#{modified_str}' /quiet /qn
          EOH
        end
      end
    end

    private

    def unzip_to_directory
      windows_zipfile "#{new_resource.workdir}/#{new_resource.name}"  do
        source full_pkg_path
	action :unzip
	not_if { ::File.exists?( full_installer_path(new_resource.name) )}
      end
    end
    
    def exe_installer
      if ::File.exists?(full_installer_path)
	exe = full_installer_path
      elsif ::File.exists?(full_installer_path(new_resource.name))
	exe = full_installer_path(new_resource.name)
      end
      exe 
    end 
  end
end

Chef::Provider.send(:include, Windows::Helper)

