default.mcafee.url = 'https://s3-us-west-2.amazonaws.com/mcafee-deploy/'
default.mcafee.epo.agenthndlr.fqdn = 'www.lepages.net'
default.mcafee.epo.agenthndlr.ip   = '50.12.23.11'
default.mcafee.epo.agenthndlr.shortname = 'epo'

case node['platform_family']
  when 'rhel', 'debian'
    default['mcafee']['vse'] = {
      'package' => 'McAfeeVSEForLinux-2.0.2.29099-release.tar.gz',
      'installer' => 'McAfeeVSEForLinux-2.0.2.29099-installer',
      'install_key' => %w(mcafeevseforlinux)
    }
    default['mcafee']['dpc'] = {
      'package' => 'MDPC1.0_Deployment_Linux.zip',
      'installer' => 'install.sh',
      'install_key' => %w(dpc)
    }
    default['mcafee']['agent'] = { 
      'package' => 'agentPackages.zip',
      'installer' => 'install.sh',
      'install_key' => %w(mfecma mfert)
    }
  when 'windows'
    default['mcafee']['agent'] = {
      'package' => 'FramePkg.exe',
      'installer' => 'FramePkg.exe',
      'install_key' => %w(McAfee\ Agent)
    }
    default['mcafee']['vse'] = {
      'package' => 'VSE880LMLRP4.Zip',
      'installer' => 'SetupVSE.exe',
      'install_key' => %w(McAfee\ VirusScan\ Enterprise)
    }
    default['mcafee']['dpc'] = {
      'package' => 'MDPC1.0_Deployment_Windows.zip',
      'installer' => 'MDPCAgent.msi',
      'install_key' => %w(McAfee\ Data\ Protection\ Agent)
    }
  end
