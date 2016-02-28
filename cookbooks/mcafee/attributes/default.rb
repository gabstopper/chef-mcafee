default['mcafee']['url'] = 'https://s3-us-west-2.amazonaws.com/mcafee-deploy/'

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
    default['mcafee']['hips'] = {
      'package' => 'tht',
      'installer' => 'erger',
      'install_key' => 'testsr'
    } 
  when 'windows'
    default['mcafee']['agent'] = {
      'package' => 'FramePkg.exe',
      'install_key' => %w(HKLM\\SYSTEM\\CurrentControlSet\\Services\\masvc)
    }
    default['mcafee']['vse'] = {
      'package' => 'rherg',
      'install_key' => %w(duh)
    }
  end
