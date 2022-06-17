# @summary
#   Configure LSST CCS DAQ related services by creating /etc/ccs config files.
#   Note that this mod is tightly coupled to the lsst/daq mod.
#
# @param owner
#   CCS user
#
# @param group
#   CCS group
#
# @param config_dir
#   CCS configuration directory
#
# @param instrument
#   Name of the camera
#
# @param daq_home
#   Installation path of daq-sdk to use for ccs apps. Defaults to `$daq::daqsdk::install_path`
#
class ccs_daq (
  String           $owner      = 'ccsadm',
  String           $group      = 'ccsadm',
  String           $config_dir = '/etc/ccs',
  String           $instrument = 'comcam',
  Optional[String] $daq_home   = undef,
) {
  require daq::daqsdk

  $version  = $daq::daqsdk::version
  $_real_daq_home = $daq_home ? {
    undef   => $daq::daqsdk::install_path,
    default => $daq_home,
  }

  if $version =~ /R(\d+)/ {
    $daq_version = $1
  } else {
    fail("Could not figure out DAQ version from ${version}")
  }

  $daq_setup = "${config_dir}/daqv${daq_version}-setup"

  file { $daq_setup:
    ensure  => file,
    content => epp("${title}/daqvX-setup.epp", { 'home' => $_real_daq_home }),
    owner   => $owner,
    group   => $group,
    mode    => '0644',
  }

  ## TODO Is it -ih for v4 and -fp for v5?
  $appfiles = ['store.app', "${instrument}-ih.app", "${instrument}-fp.app"]

  $appfiles.each | $appfile | {
    file { "${config_dir}/${appfile}":
      ensure  => file,
      content => epp("${title}/daq.app.epp", { 'setup_file' => "${basename($daq_setup)}" }),
      owner   => $owner,
      group   => $group,
      mode    => '0644',
    }
  }

  # cleanup old daq-sdk installation path -- now handled by lsst/daq
  file { '/opt/lsst/daq':
    ensure => absent,
    force  => true,
  }
}
