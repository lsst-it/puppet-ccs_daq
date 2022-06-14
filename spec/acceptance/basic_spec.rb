# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'daq class' do
  let(:pp) do
    <<-PP
    group { 'ccsadm': }
    user { 'ccsadm': gid => 'ccsadm' }

    file { '/etc/ccs':  # normally created by lsst/ccs_software
      ensure => directory,
      owner  => 'ccsadm',
      group  => 'ccsadm',
      mode   => '0755',
    }

    class { 'daq::daqsdk':
      version => 'R5-V0.6',
    }

    include ccs_daq
    PP
  end

  it_behaves_like 'an idempotent resource'

  %w[
    /etc/ccs/store.app
    /etc/ccs/comcam-ih.app
    /etc/ccs/comcam-fp.app
  ].each do |f|
    describe file(f) do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'ccsadm' }
      it { is_expected.to be_grouped_into 'ccsadm' }
      it { is_expected.to be_mode '644' } # serverspec does not like a leading 0
      its(:content) { is_expected.to match %r{system.pre-execute=daqv5-setup} }
    end
  end

  describe file('/etc/ccs/daqv5-setup') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'ccsadm' }
    it { is_expected.to be_grouped_into 'ccsadm' }
    it { is_expected.to be_mode '644' } # serverspec does not like a leading 0
    its(:content) { is_expected.to match %r{export DAQ_HOME=/opt/lsst/daq-sdk/R5-V0.6} }
  end

  describe file('/opt/lsst/daq') do
    it { is_expected.not_to exist }
  end
end
