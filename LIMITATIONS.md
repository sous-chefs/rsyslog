# Limitations

## Package Availability

Rsyslog is included in the package repositories for major Linux distributions. The upstream project recommends distribution packages for routine installs and provides current Adiscon packages for Ubuntu, Debian, RHEL/CentOS, and Alpine when newer rsyslog versions are required.

This cookbook manages distro packages only. It does not configure upstream Adiscon repositories, OBS repositories, Docker images, or source builds.

### APT (Debian/Ubuntu)

* Ubuntu 22.04 and 24.04 are supported through distro packages.
* Debian 12 is supported through distro packages.
* Upstream Adiscon Ubuntu packages follow Ubuntu versions that have not reached end of life under Ubuntu policy.

### DNF/YUM (RHEL family)

* AlmaLinux 8 and 9, Amazon Linux 2023, CentOS Stream 9, Oracle Linux 8 and 9, Red Hat Enterprise Linux 8 and 9, and Rocky Linux 8 and 9 are expected to have distro rsyslog packages.
* RHEL-compatible 8 releases are in maintenance/security support rather than full active support, but are not end-of-life.

### Zypper (SUSE)

* openSUSE Leap 15.6 reaches end of life on April 30, 2026.
* openSUSE Leap 16 is not included in the Dokken matrix here because a matching Dokken image was not present in the existing cookbook configuration.

## Architecture Limitations

This cookbook does not constrain CPU architecture directly. Package availability is delegated to the operating system repositories for the selected platform.

## Source/Compiled Installation

Source builds are not supported by these resources. Install rsyslog from distribution packages before using this cookbook if your platform is outside the supported matrix.

## Known Issues

* This is a Linux systemd-only migration. Legacy SmartOS and OmniOS service management was removed with the recipe migration.
* `rsyslog_client` does not perform Chef search unless the `server_search` property is explicitly set.
* RELP package names vary by family: SUSE uses `rsyslog-module-relp`; other supported families use `rsyslog-relp`.

## References

* https://docs.rsyslog.com/doc/installation/packages.html
* https://www.rsyslog.com/downloads/
* https://www.rsyslog.com/ubuntu-repository/
* https://endoflife.date/ubuntu
* https://endoflife.date/debian
* https://endoflife.date/rhel
* https://endoflife.date/amazon-linux
* https://endoflife.date/centos-stream
* https://endoflife.date/almalinux
* https://endoflife.date/rocky-linux
* https://endoflife.date/oracle-linux
* https://endoflife.date/fedora
* https://endoflife.date/opensuse
