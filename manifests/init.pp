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
# @param apps_noinstrument
#   If true, do not include "instrument-" in the /etc/ccs/*.app names.
#
class ccs_daq (
  String $owner = 'ccsadm',
  String $group = 'ccsadm',
  String $config_dir = '/etc/ccs',
  String $instrument = 'comcam',
  Boolean $apps_noinstrument = false,
) {
  require daq::daqsdk

  $version  = $daq::daqsdk::version
  $daq_home = "${daq::daqsdk::base_path}/ccs-production"

  if $version =~ /R(\d+)/ {
    $daq_version = $1
  } else {
    fail("Could not figure out DAQ version from ${version}")
  }

  $daq_setup = "${config_dir}/daqv${daq_version}-setup"

  # XXX the file type's replace param does not work for symlinks
  # https://github.com/puppetlabs/puppet/pull/8643
  # https://tickets.puppetlabs.com/browse/PUP-10214
  exec { "create but not update ${daq_home} symlink":
    path    => ['/bin', '/usr/bin'],
    command => "ln -snf ${basename($daq::daqsdk::install_path)} ${daq_home}",
    # creates => $daq_home, XXX creates will trigger on dangling symlinks
    unless  => "test -L ${daq_home}",
  }
  -> file { $daq_home:
    owner => $owner,
    group => $group,
  }

  file { $daq_setup:
    ensure  => file,
    content => epp("${title}/daqvX-setup.epp", { 'home' => $daq_home }),
    owner   => $owner,
    group   => $group,
    mode    => '0644',
  }

  if $apps_noinstrument {
    $appfiles = ['store.app', 'image-handling.app', 'focal-plane.app']
  } else {
    $appfiles = ['store.app', "${instrument}-ih.app", "${instrument}-fp.app"]
  }

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
