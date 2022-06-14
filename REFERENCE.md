# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

* [`ccs_daq`](#ccs_daq): Configure LSST CCS DAQ related services by creating /etc/ccs config files.
Note that this mod is tightly coupled to the lsst/daq mod.

## Classes

### <a name="ccs_daq"></a>`ccs_daq`

Configure LSST CCS DAQ related services by creating /etc/ccs config files.
Note that this mod is tightly coupled to the lsst/daq mod.

#### Parameters

The following parameters are available in the `ccs_daq` class:

* [`owner`](#owner)
* [`group`](#group)
* [`config_dir`](#config_dir)
* [`instrument`](#instrument)

##### <a name="owner"></a>`owner`

Data type: `String`

CCS user

Default value: `'ccsadm'`

##### <a name="group"></a>`group`

Data type: `String`

CCS group

Default value: `'ccsadm'`

##### <a name="config_dir"></a>`config_dir`

Data type: `String`

CCS configuration directory

Default value: `'/etc/ccs'`

##### <a name="instrument"></a>`instrument`

Data type: `String`

Name of the camera

Default value: `'comcam'`
