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
      'installer' => 'FramePkg.exe',
      'install_key' => %w(HKEY_CLASSES_ROOT\\Installer\\Products\\7BF432EAB6AE684439D9D0D24ACDEF72)
    }
    default['mcafee']['vse'] = {
      'package' => 'VSE880LMLRP4.Zip',
      'installer' => 'SetupVSE.exe',
      'install_key' => %w(HKEY_CLASSES_ROOT\\Installer\\Products\\6B1D51EC6B91D4D4F834FCD5C23365FF)
    }
    default['mcafee']['dpc'] = {
      'package' => 'MDPC1.0_Deployment_Windows.zip',
      'installer' => 'MDPCAgent.msi',
      'install_key' => %w(HKEY_CLASSES_ROOT\\Installer\\Products\\AC98CBF50DB092F4AA20D9945604D77C)
    }
  end
