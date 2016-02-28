module McafeeCookbook
  module Helpers
    module Linux
      include Chef::Mixin::ShellOut

      def pkg_exists?(pkg)
	target = "#{node['mcafee'][pkg]['install_key'].first}"
	case node['platform_family']
	when 'debian'
	  cmd = shell_out("dpkg-query -W #{target}")
	  cmd.stdout =~ /#{node['mcafee'][pkg]['install_key']}/
	end
	#TODO RHEL
      end

      def run_install
	case new_resource.name
        when 'agent'
          install_agent
        when 'vse'
          install_vse
        when 'hips'
	  #TODO
          Chef::Log.info("Install hips")
        when 'dpc'
          install_dpc
        end
      end

      def run_remove
        if "#{new_resource.name}" == 'agent'	
	  package %w(mfecma mfert) do
	    action :purge
	  end
	else
	  package "#{new_resource.name}" do
	    action :purge
	  end
	end
      end
	
      def install_agent
	Chef::Log.info("You just called linux install_agent")
	package 'unzip' do
	  action :install
	end
	bash 'run_agent_install' do
	  code <<-EOH
	    sudo unzip -o #{new_resource.workdir}/agentPackages.zip -d #{new_resource.workdir}
	    sudo chmod a+x #{new_resource.workdir}/install.sh
	    sudo bash #{new_resource.workdir}/install.sh -i
	    EOH
	notifies :run, 'execute[contact_epo]', :delayed
	end
	execute 'contact_epo' do
	  command "sudo /opt/McAfee/cma/bin/cmdagent -p"
	  action :nothing
	end
      end

      def install_vse
	cookbook_file "#{ENV['HOME']}/nails.options" do
	  source 'nails.options'
	  mode '0644'
	  action :create
	end
	bash 'run_vse_install' do
	  code <<-EOH
	    sudo tar -xzvf #{new_resource.workdir}/#{node['mcafee']['vse']['package']} -C #{new_resource.workdir}
	    sudo bash #{new_resource.workdir}/#{node['mcafee']['vse']['installer']}
	    EOH
	end
      end

      def install_dpc
	package 'unzip' do
	  :install
	end
	bash 'run_dpc_install' do
	  code <<-EOH
	    sudo unzip -o #{new_resource.workdir}/#{node['mcafee']['dpc']['package']} -d #{new_resource.workdir}
	    cd #{new_resource.workdir}
	    sudo chmod a+x #{new_resource.workdir}/install.sh
	    sudo bash #{new_resource.workdir}/install.sh -i
	  EOH
	end
      end     
    end
  end
end

