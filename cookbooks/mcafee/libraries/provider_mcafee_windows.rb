class Chef
  class Provider::McafeeWindows < Chef::Provider::LWRPBase
    include McafeeCookbook::Helpers::Windows

    provides :mcafee, os: 'windows'
    use_inline_resources

    def whyrun_supported?
      true
    end

    action :install do
      #installed = installed_packages
      #Chef::Log.info("installed::: #{installed}")
      unless pkg_exists?(new_resource.name)
        converge_by("Completed windows provider") do
	  app_package = local_file(new_resource.name)
	  if new_resource.url
	    remote_file app_package do
	      source from_url
	      action :create_if_missing
	    end
	  elsif new_resource.cookbook_file
	    #TODO
	  elsif new_resource.uncpath
	    #TODO
	  else
	    remote_file app_package do
	      source from_attribute
	      action :create_if_missing
	    end 
	  end
	  Chef::Log.info("Calling installer for #{new_resource.name}")
	  run_install
        end
      else
	Chef::Log.warn("Application '#{new_resource.name}' already installed")
      end
    end

    action :remove do
      if pkg_exists?(new_resource.name)
	Chef::Log.info("Calling uninstall for #{new_resource.name}")
        run_remove
      else
	Chef::Log.warn("Application '#{new_resource.name}' is not installed")
      end
    end

    def load_current_resource
      @current_resource ||= Resource::Mcafee.new(new_resource.name)
      unless ::File.exists?(new_resource.workdir)
        new_resource.workdir = "#{Chef::Config[:file_cache_path]}"
      end
      @current_resource.workdir = @new_resource.workdir

      @current_resource	
    end 

    def package_name
      node['mcafee']["#{new_resource.name}"]['package']
    end

    def from_attribute
      "#{node['mcafee']['url']}#{node['mcafee'][new_resource.name]['package']}"
    end

    def from_url
      "#{new_resource.url}/#{package_name}"
    end
    
    def from cookbook_file
      #TODO
    end

    def from uncpath
      #TODO
    end

    def local_file(name) #fully qualified path for downloaded file
      "#{new_resource.workdir}/#{node['mcafee'][name]['package']}"
    end
  end
end
