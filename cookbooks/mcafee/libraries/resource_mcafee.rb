class Chef
  class Resource::Mcafee < Chef::Resource::LWRPBase
    resource_name :mcafee

    # Actions
    actions :install, :remove
    default_action :install

    # Attributes
    attribute :name, kind_of: String, equal_to: ['agent', 'vse', 'dpc', 'hips'], required:true, name_attribute: true
    attribute :url, kind_of: String
    attribute :uncpath, kind_of: String
    attribute :cookbook_file, kind_of: String
    attribute :workdir, kind_of: String, default: "#{Chef::Config[:file_cache_path]}"

  end
end

