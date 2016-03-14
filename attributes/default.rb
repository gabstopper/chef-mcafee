default.mcafee.url = 'https://s3-us-west-2.amazonaws.com/mcafee-deploy/'
default.mcafee.epo.agenthndlr.fqdn = 'www.lepages.net'
default.mcafee.epo.agenthndlr.ip   = '1.1.1.1'
default.mcafee.epo.agenthndlr.shortname = 'epo'

case node['platform_family']
  when 'rhel', 'debian', 'suse'
    default['mcafee']['vse'] = {
      'package' => 'McAfeeVSEForLinux-2.0.2.29099-release.tar.gz',
      'installer' => 'McAfeeVSEForLinux-2.0.2.29099-installer',
      'install_key' => ['McAfeeVSEForLinux', 'ISecGRt']
      #'install_key' => %w(McAfeeVSEForLinux ISecGRt)
    }
    default['mcafee']['dpc'] = {
      'package' => 'MDPC1.0_Deployment_Linux.zip',
      'installer' => 'install.sh',
      'install_key' => ['dpc']
      #'install_key' => %w(dpc)
    }
    default['mcafee']['agent'] = { 
      'package' => 'agentPackages.zip',
      'installer' => 'install.sh',
      'install_key' => ['MFEcma', 'MFErt']
      #'install_key' => %w(MFEcma MFErt)
    }
  when 'windows'
    default['mcafee']['agent'] = {
      'package' => 'FramePkg.exe',
      'installer' => 'FramePkg.exe',
      'install_key' => ['McAfee Agent']
      #'install_key' => %w(McAfee\ Agent)
    }
    default['mcafee']['vse'] = {
      'package' => 'VSE880LMLRP7.Zip',
      'installer' => 'SetupVSE.exe',
      'install_key' => ['McAfee VirusScan Enterprise']
      #'install_key' => %w(McAfee\ VirusScan\ Enterprise)
    }
    default['mcafee']['dpc'] = {
      'package' => 'MDPC1.0_Deployment_Windows.zip',
      'installer' => 'MDPCAgent.msi',
      'install_key' => ['McAfee Data Protection Agent']
      #'install_key' => %w(McAfee\ Data\ Protection\ Agent)
    }
  end
