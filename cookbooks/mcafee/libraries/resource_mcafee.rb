class Chef
  class Resource::Mcafee < Chef::Resource::LWRPBase
    resource_name :mcafee

    # Actions
    actions :install, :remove
    default_action :install

    # Attributes
    attribute :name, kind_of: String, equal_to: ['agent', 'vse', 'dpc', 'hips'], required: true, name_attribute: true
    attribute :url, kind_of: String
    attribute :uncpath, kind_of: String
    attribute :cookbook_file, kind_of: String
    attribute :workdir, kind_of: String, default: Chef::Config[:file_cache_path]
    attribute :product_info, kind_of: Hash, default: {:package=>nil, :installer=>nil, :install_key=>nil},
	:callbacks => { "Missing product_info field!" => lambda { |p| [:package,:installer,:install_key] == p.keys }}
  end
end

