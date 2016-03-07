module McafeeCookbook
  module Helpers

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
      path = Pathname(new_resource.workdir) + new_resource.product_info[:package]
      unless subdir.nil?
	path = Pathname(new_resource.workdir) + subdir + new_resource_product_info[:installer]
      end	
      path.to_s
    end

    def full_installer_path(subdir = nil)
      path = Pathname(new_resource.workdir) + new_resource.product_info[:installer]
      unless subdir.nil?
	path = Pathname(new_resource.workdir) + subdir + new_resource.product_info[:installer]
      end
      path.to_s
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

    #where the product info comes from
    def from_attribute
      "#{node['mcafee']['url']}#{node['mcafee'][new_resource.name]['package']}"
    end

    def from_url
      t = strip_trailing_slash( new_resource.url )
      "#{t}/#{new_resource.product_info[:package]}"
    end

    def from cookbook_file
      #TODO
    end

    def from uncpath
      #TODO
    end

    def strip_trailing_slash(str)
      str.gsub(/\/+$/, '')
    end
  end
end
