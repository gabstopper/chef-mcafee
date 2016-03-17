module McafeeCookbook
  module Helpers

    def download_pkgs
      if new_resource.url
        remote_file full_pkg_path do
          source url_from_recipe
          action :create_if_missing
        end
      elsif new_resource.cookbook_file
        #TODO
      elsif new_resource.uncpath
        #TODO
      else
        remote_file full_pkg_path do	#from attributes/default.rb
          source url_from_attribute
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

    def load_product_info
      if new_resource.product_info.values.include? nil
        new_resource.product_info({
          :package => node['mcafee'][new_resource.name]['package'],
          :installer => node['mcafee'][new_resource.name]['installer'],
          :install_key => node['mcafee'][new_resource.name]['install_key']
        })
      end
      Chef::Log.info "Resolved product_info: #{new_resource.product_info}"
    end

    #where the product info comes from
    def url_from_attribute
      generate_download_url(node['mcafee']['url'])
    end

    def url_from_recipe
      generate_download_url(new_resource.url)
    end

    def generate_download_url(base_url)
      base_url.gsub(/\/+$/, '') + "/" + new_resource.product_info[:package] 
    end

    def from cookbook_file
      #TODO
    end

    def from uncpath
      #TODO
    end
  end
end

