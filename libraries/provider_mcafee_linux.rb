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
        converge_by('Installing on Linux platform') do
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

      unless ::File.directory?(new_resource.workdir)
        new_resource.workdir = Chef::Config[:file_cache_path]
      end

      load_product_info

      current_resource
    end
  
    def pkg_exists?
      target = new_resource.product_info[:install_key].first
      case node[:platform]
      when 'debian', 'ubuntu'
	cmd = shell_out ("dpkg -s #{target} | grep Status | awk '{print $NF}'")
	cmd.stdout =~ /installed/	
      when 'redhat', 'amazon', 'centos', 'suse'
	cmd = shell_out("rpm -qa | grep -i #{target}")
	cmd.stdout =~ /#{target}/
      end
    end

    def run_install
      unzip_to_directory if ::File.extname(new_resource.product_info[:package]) =~ /\.(zip)$/i 
      case new_resource.name
      when 'agent'      
	execute 'run_agent_install' do
	  command "bash #{full_installer_path} -i"
	  action :run
	end
        execute 'contact_epo' do
          command "/opt/McAfee/cma/bin/cmdagent -p"
          action :run
        end
      when 'vse' 
	case node['platform_family']
	when 'rhel', 'suse' #minimal install on rhel, suse and centos may be missing these required packages
	  package ['ed', 'net-tools', 'bind-utils']  do
	    action :install
	  end
	end
	execute "unpack_tar_gz" do
	  command "tar -xzf #{full_pkg_path} -C #{new_resource.workdir}"
	  action :run
	end
        cookbook_file "#{ENV['HOME']}/nails.options" do
          source 'nails.options'
          mode '0644'
          action :create
        end
	execute "run_bash_install" do
	  command "bash #{full_installer_path}"
	  action :run
	end
      when 'dpc'
	execute 'run_dpc_install' do
	  #command "bash #{new_resource.workdir}/install.sh -i"
	  command "bash #{full_installer_path} -i"
	  cwd new_resource.workdir
	  action :run
        end 
      end
    end

    def run_remove
      products = new_resource.product_info[:install_key]
      products.each do |product|
	case node['platform_family']
	when 'debian' #case sensitive on when running apt-cache on older ubuntu releases
	  product = product.downcase
	end
	package product do
	  action :purge
	end 
      end
    end

    private

    def unzip_to_directory
      package 'unzip' do
        action :install
      end
      execute "unzip_package" do
        command "unzip -o #{full_pkg_path} -d #{new_resource.workdir}"
        action :run
      end
    end
  end
end
