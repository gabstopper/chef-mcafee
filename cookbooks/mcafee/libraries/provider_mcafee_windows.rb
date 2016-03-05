class Chef
  class Provider::McafeeWindows < Chef::Provider::LWRPBase
    include McafeeCookbook::Helpers::Windows

    provides :mcafee, os: 'windows'
    use_inline_resources

    def whyrun_supported?
      true
    end

    action :install do
      unless pkg_exists?(new_resource.name)
        converge_by("Converging Windows platform") do
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
	  run_install
        end
      else
	Chef::Log.info "Application '#{new_resource.name}' already installed"
      end
    end

    action :remove do
      if pkg_exists?(new_resource.name)
        #Chef::Log.info "Pathname: #{new_resource.workdir}/#{Pathname(new_resource.name).basename}"
	Chef::Log.info "Calling uninstall for #{new_resource.name}"
        run_remove
      else
	Chef::Log.info "Application '#{new_resource.name}' is not installed"
      end
    end

    def load_current_resource
      @current_resource ||= Resource::Mcafee.new(new_resource.name)
      unless ::File.exists?(new_resource.workdir)
        new_resource.workdir = Chef::Config[:file_cache_path]
      end
      @current_resource.workdir = @new_resource.workdir
      
      if attributes_missing?
	attributes_from_node
      end

      @current_resource	
    end 

    def attributes_from_node
      new_resource.product_info({
        :package => node['mcafee'][new_resource.name]['package'],
	:installer => node['mcafee'][new_resource.name]['installer'],
	:install_key => node['mcafee'][new_resource.name]['install_key'] 
      })
      Chef::Log.info "Product info set from attributes: #{new_resource.product_info}"
      if attributes_missing? #if attributes not provided in recipe, check attributes file
        fail "Missing attributes required to proceed. Attributes are either configured in the chef recipe or in the cookbooks attribute file."
      end
    end

    def attributes_missing?
      new_resource.product_info.values.include? nil
    end
      
    def package_name
      new_resource.product_info[:package] 
      #node['mcafee'][new_resource.name]['package']
    end

    def from_attribute
      "#{node['mcafee']['url']}#{node['mcafee'][new_resource.name]['package']}"
      #"#{node['mcafee']['url']}#{new_resource.product_info[:package]}"
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
