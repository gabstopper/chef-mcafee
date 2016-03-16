class Chef
  class Provider::McafeeLinux < Chef::Provider::LWRPBase
    include McafeeCookbook::Helpers
    include Chef::Mixin::ShellOut

    provides :mcafee, os: 'linux', platform_family: %w(rhel debian suse)
    use_inline_resources

    def whyrun_supported?
      true 
    end

    action :install do
      if pkg_exists?
	Chef::Log.info "Application #{new_resource.name} already installed, doing nothing"
      else
        converge_by('Install on Linux platform') do
	  download_pkgs
	  run_install
        end
      end
    end
   
    action :remove do
      if pkg_exists?     
        converge_by('Removing package on Linux') do
          run_remove
        end
      end
    end
   
    def load_current_resource
      @current_resource ||= Resource::Mcafee.new(new_resource.name)

      unless ::File.exists?(new_resource.workdir)
        new_resource.workdir = Chef::Config[:file_cache_path]
      end
      #current_resource.workdir(new_resource.workdir)

      if attributes_missing?
        attributes_from_node
      end

      #current_resource.input(compile_products(new_resource.input))
      #Chef::Log.info "Input is: #{current_resource.input}"
      #current_resource.input.each do |y|
	#unless is_valid_product?(y)
	#  raise "Invalid product provided in name attribute: #{y}"
	#end
      #end

      current_resource
    end
  
    def pkg_exists?
      target = node['mcafee'][new_resource.name]['install_key'].first
      case node[:platform]
      when 'debian', 'ubuntu'
	cmd = shell_out ("dpkg -s #{target} | grep Status | awk '{print $NF}'")
	cmd.stdout =~ /installed/	
      when 'redhat', 'amazon', 'centos', 'suse'
	cmd = shell_out("rpm -qa | grep -i #{target}")
	cmd.stdout =~ /#{node['mcafee'][new_resource.name]['install_key']}/
      end
    end

    def run_install
      case new_resource.name
      when 'agent'      
        package 'unzip' do
          action :install
        end
        bash 'run_agent_install' do
          code <<-EOH
            unzip -o #{full_pkg_path} -d #{new_resource.workdir}
            chmod a+x #{full_installer_path}
            bash #{full_installer_path} -i
            EOH
          notifies :run, 'execute[contact_epo]', :delayed
        end
        execute 'contact_epo' do
          command "/opt/McAfee/cma/bin/cmdagent -p"
          action :nothing
        end
      when 'vse' 
        cookbook_file "#{ENV['HOME']}/nails.options" do
          source 'nails.options'
          mode '0644'
          action :create
        end
	case node['platform_family']
	when 'rhel', 'suse' #minimal install on rhel, suse and centos may be missing these required packages
	  package ['ed', 'net-tools', 'bind-utils']  do
	    action :install
	  end
	end
        bash 'run_vse_install' do
          code <<-EOH
            tar -xzf #{full_pkg_path} -C #{new_resource.workdir}
            bash #{full_installer_path}
            EOH
        end
      when 'dpc'
        package 'unzip' do
          :install
        end
        bash 'run_dpc_install' do
          code <<-EOH
            unzip -o #{full_pkg_path} -d #{new_resource.workdir}
            cd #{new_resource.workdir}
            chmod a+x #{new_resource.workdir}/install.sh
            bash #{new_resource.workdir}/install.sh -i
          EOH
	end
      end
    end

    def run_remove
      products = new_resource.product_info[:install_key]
      products.each do |product|
	case node['platform_family']
	when 'debian' #case sensitive on package name for some reason
	  product = product.downcase
	end
	package product do
	  action :purge
	end 
      end
    end
  end
end
