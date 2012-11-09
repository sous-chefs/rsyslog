## v1.2.0:

* Remove Ubuntu 8.04 code
* Introduce attributes for `defaults_file` and `service_name`
* Made code use largely ignored existing attributes for file+dir
  `owner` and `group`
* Introduced RHEL 6 support (rsyslog is the OS default at 6.0+)
* No longer use any form of "complete" `/etc/rsyslog.conf`. Only
  supporting `$IncludeConfig` + individual `/etc/rsyslog.d conf` files.
  Previously, the `default` recipe for non-Ubuntu would make a
  self-contained /etc/rsyslog.conf
* Raise an exception in the `client` recipe if we cannot determine
  the server to log to.

## v1.1.0:

Changes from COOK-1167:

* More versatile server discovery - use the IP as an attribute, or use
  search (see README)
* Removed cron dependency.
* Removed log archival; logrotate is recommended.
* Add an attribute to select the per-host directory in the log dir
* Works with Chef Solo now.
* Set debian/ubuntu default user and group. Drop privileges to `syslog.adm`.


## v1.0.0:

* [COOK-836] - use an attribute to specify the role to search for
  instead of relying on the rsyslog['server'] attribute.
* Clean up attribute usage to use strings instead of symbols.
* Update this README.
* Better handling for chef-solo.
