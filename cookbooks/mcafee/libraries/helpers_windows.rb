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
	    :name => 'DisplayName',
	    :type => :string,
	    :data => 'McAfee Agent Service' },
	    :machine )
	  rescue
	    false
	  end
	when 'vse'
	  false
	when 'dpc'
	  false
	when 'hips'
	  false
	end  
      end

      def run_install
	case new_resource.name
        when 'agent'
          install_winagent
        when 'vse'
          install_vse
        when 'hips'
	  #TODO
          Chef::Log.info("Install hips")
        when 'dpc'
          install_dpc
        end
      end
    
      def install_vse2
	Chef::Log.info("installing vse")
      end

      def install_agent
	Chef::Log.info "Going to install agent: #{new_resource.workdir}/#{node['mcafee']['agent']['package']}"
	package 'McAfee Agent' do
	  source "#{new_resource.workdir}/#{node['mcafee']['agent']['package']}"
	  installer_type :custom
	  options '/install=agent /silent'
	end
      end

      def run_remove
	#FramePkg.exe /remove=agent
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
      end

      def install_vse
      end

      def install_dpc
      end     

    end
  end
end
