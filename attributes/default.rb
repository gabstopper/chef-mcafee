default['mcafee']['url'] = 'https://s3-us-west-2.amazonaws.com/mcafee-deploy/'

case node['platform_family']
  when 'rhel', 'debian', 'suse'
    default['mcafee']['vse'] = {
      'package' => 'McAfeeVSEForLinux-2.0.2.29099-release.tar.gz',
      'installer' => 'McAfeeVSEForLinux-2.0.2.29099-installer',
      'install_key' => ['McAfeeVSEForLinux', 'ISecGRt']
    }
    default['mcafee']['dpc'] = {
      'package' => 'MDPC1.0_Deployment_Linux.zip',
      'installer' => 'install.sh',
      'install_key' => ['dpc']
    }
    default['mcafee']['agent'] = { 
      'package' => 'agentPackages.zip',
      'installer' => 'install.sh',
      'install_key' => ['MFEcma', 'MFErt']
    }
  when 'windows'
    default['mcafee']['agent'] = {
      'package' => 'FramePkg.exe',
      'installer' => 'FramePkg.exe',
      'install_key' => ['McAfee Agent']
    }
    default['mcafee']['vse'] = {
      'package' => 'VSE880LMLRP7.Zip',
      'installer' => 'SetupVSE.exe',
      'install_key' => ['McAfee VirusScan Enterprise']
    }
    default['mcafee']['dpc'] = {
      'package' => 'MDPC1.0_Deployment_Windows.zip',
      'installer' => 'MDPCAgent.msi',
      'install_key' => ['McAfee Data Protection Agent']
    }
  end
