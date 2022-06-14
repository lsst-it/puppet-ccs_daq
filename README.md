# ccs_daq

## Table of Contents

1. [Overview](#overview)
1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)

## Overview

Configure LSST CCS DAQ related services.

## Description

Note that this mod is tightly coupled to the
[`lsst/daq`](https://github.com/lsst-it/puppet-daq) mod.

## Usage

### Hiera Example

```yaml
---
classes:
  - "ccs_daq"
  - "daq::daqsdk"

daq::daqsdk: "R5-V3.2"
```

## Reference

See [REFERENCE](REFERENCE.md)
