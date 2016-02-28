class Chef
  class Provider::McafeeLinux < Chef::Provider::LWRPBase
    include McafeeCookbook::Helpers::Linux

    provides :mcafee, os: 'linux', platform_family: %w(rhel debian)
    use_inline_resources

    def whyrun_supported?
      true 
    end

    action :install do
      unless pkg_exists?(new_resource.name)
        converge_by('Install McAfee product on Linux') do
	  app_package = local_file(new_resource.name)
	  if new_resource.url
	    remote_file app_package do
              source from_url
	      action :create_if_missing	
	    end
	    Chef::Log.info("Install product from url: #{new_resource.url}")
	  elsif new_resource.cookbook_file
	    #TODO
          elsif new_resource.uncpath
	    #TODO
	  else
	    remote_file app_package do
              source from_attribute
	      action :create_if_missing	
	    end
	    Chef::Log.info("Install product from attribute file")
	  end
	  run_install
        end
      else
	Chef::Log.warn("McAfee product: '#{new_resource.name}' already installed, skipping")
      end
    end
   
    action :remove do
      run_remove
    end
   
    def load_current_resource
      @current_resource ||= Resource::Mcafee.new(new_resource.name)
      unless ::File.exists?(new_resource.workdir)
        new_resource.workdir = "#{Chef::Config[:file_cache_path]}"
      end
      @current_resource.workdir = @new_resource.workdir
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
