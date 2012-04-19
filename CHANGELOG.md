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
