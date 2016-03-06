module McafeeCookbook
  module Helpers

    #Chef::Log.info "Pathname: #{new_resource.workdir}/#{Pathname(new_resource.name).basename}"
    def download_pkgs
      if new_resource.url
        remote_file full_pkg_path do
          source from_url
          action :create_if_missing
        end
      elsif new_resource.cookbook_file
        #TODO
      elsif new_resource.uncpath
        #TODO
      else
        remote_file full_pkg_path do
          source from_attribute
          action :create_if_missing
        end
      end
    end

    def full_pkg_path(subdir = nil)
      if subdir.nil?
        "#{new_resource.workdir}/#{new_resource.product_info[:package]}"
      else
        "#{new_resource.workdir}/#{subdir}/#{new_resource.product_info[:package]}"
      end	
    end

    def full_installer_path(subdir = nil)
      if subdir.nil?
        "#{new_resource.workdir}/#{new_resource.product_info[:installer]}"
      else
        "#{new_resource.workdir}/#{subdir}/#{new_resource.product_info[:installer]}"
      end
    end

    def attributes_missing?
      new_resource.product_info.values.include? nil
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

    #get the path to the downloads from attributes file
    def from_attribute
      "#{node['mcafee']['url']}#{node['mcafee'][new_resource.name]['package']}"
    end

    def from_url
      "#{new_resource.url}/#{new_resource.product_info[:package]}"
    end

    def from cookbook_file
      #TODO
    end

    def from uncpath
      #TODO
    end
  end
end
