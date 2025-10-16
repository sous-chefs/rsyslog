# rsyslog Cookbook CHANGELOG

This file is used to list changes made in each version of the rsyslog cookbook.

Standardise files with files in sous-chefs/repo-management
Standardise files with files in sous-chefs/repo-management

## [11.0.2](https://github.com/sous-chefs/rsyslog/compare/11.0.1...v11.0.2) (2025-10-16)


### Bug Fixes

* **ci:** Update workflows to use release pipeline ([#245](https://github.com/sous-chefs/rsyslog/issues/245)) ([61c4d96](https://github.com/sous-chefs/rsyslog/commit/61c4d96aaba5cd6b36d16eb56c39ba65f67c0ce2))

## 11.0.0 - *2024-12-18*

Allow module parameters to be configurable by attributes
e.g.`node['rsyslog']['imuxsock_directives']`

## 10.0.0 - *2024-12-12*

* Update rsyslog.conf template to support newer platforms
* Update platforms tested in CI

## 9.2.24 - *2024-11-18*

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

## 9.2.23 - *2024-07-15*

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

## 9.2.22 - *2024-05-22*

Standardise files with files in sous-chefs/repo-management

## 9.2.18 - *2024-02-02*

Make `$InputTCPMaxSessions` configurable via
`node['rsyslog']['tcp_max_sessions']` attribute.

## 9.2.11 - *2023-04-07*

Standardise files with files in sous-chefs/repo-management

## 9.2.8 - *2023-04-01*

Standardise files with files in sous-chefs/repo-management

## 9.2.7 - *2023-03-20*

Standardise files with files in sous-chefs/repo-management

## 9.2.6 - *2023-03-15*

Standardise files with files in sous-chefs/repo-management

## 9.2.5 - *2023-02-23*

Standardise files with files in sous-chefs/repo-management

## 9.2.4 - *2023-02-16*

Standardise files with files in sous-chefs/repo-management

## 9.2.2 - *2023-02-14*

Standardise files with files in sous-chefs/repo-management

## 9.2.1 - *2022-12-15*

* Standardise files with files in sous-chefs/repo-management

## 9.2.0 - *2022-09-27*

* Allow omitting $MaxMessageSize from config

## 9.1.0 - *2022-02-26*

* Use `gnutls` for TLS support on CentOS 7
* Update tested platforms
* Switch to reusable CI workflow

## 9.0.3 - *2022-02-10*

* Standardise files with files in sous-chefs/repo-management

## 9.0.2 - *2022-02-08*

* Remove delivery folder

## 9.0.1 - *2021-08-30*

* Standardise files with files in sous-chefs/repo-management

## 9.0.0 - *2021-06-18*

* Chef 17 updates: enable `unified_mode` on all resources
* Bump required Chef Infra Client to >= 15.3
* Remove support and testing for RHEL 6 and Ubuntu 16.04

## 8.0.3 - *2021-06-01*

* Standardise files with files in sous-chefs/repo-management

## 8.0.2 - *2021-04-14*

* Add check for FreeBSD to prevent trying to install a RELP package

## 8.0.1 - *2021-01-04*

* Cookstyle Bot Auto Corrections with Cookstyle 7.5.3

## 8.0.0 - *2020-12-03*

* Cookstyle fix
* Two final references to `use_imfile` removed.
* Automatically include `imfile` module with `rsyslog_file_input`
* rspec test fix: SmartOS is version 5.11
* Removed $ModLod from `rsyslog_file_input` resource
* Move `labeled_template` helper method to `helpers.rb` file

## 7.6.0 - *2020-12-03*

* Bring default configuration for SmartOS inline with current distribution from pkgsrc and note SmartOS as a supported package.

## 7.5.0 - *2020-12-01*

* Fix log directory ownership

## 7.4.0 - *2020-11-25*

* Add facility to choose TLS driver

## 7.3.0 - *2020-11-23*

* Enabled custom templates for rsyslog `35-server-per-host.conf` file.

## 7.2.1 - *2020-11-23*

* Fixed a bug during the release of 7.2.0
   * Add an attribute for setting the mode on the configuration directory

## 7.2.0 - *2020-11-23*

* Add an attribute for setting the mode on the configuration directory

## 7.1.0 (2020-10-26)

### Changed

* Sous Chefs Adoption
* Update Changelog to Sous Chefs
* Update to use Sous Chefs GH workflow
* Update README to sous-chefs
* Update metadata.rb to Sous Chefs
* Update test-kitchen to Sous Chefs
* Migrate to InSpec for integration tests

### Fixed

* resolved cookstyle error: spec/default_spec.rb:236:7 warning: `ChefDeprecations/DeprecatedChefSpecPlatform`
* resolved cookstyle error: recipes/client.rb:44:7 refactor: `ChefCorrectness/ChefApplicationFatal`
* Cookstyle fixes
* ChefSpec fixes
* Yamllint fixes
* Fix RELP on SuSE platforms

### Added

* Add mdlrc file
* Add Ubuntu 20.04 testing
* Add an attribute for setting the mode on the configuration directory

### Removed

* Remove Amazon Linux 1 testing
* Remove EL 6 testing

## 7.0.1 (2019-12-23)

* Fix the systemd detection logic - [@tas50](https://github.com/tas50)

## 7.0.0 (2019-12-23)

* Update for Chef 15 license agreement and Chef Workstation - [@tas50](https://github.com/tas50)
* Resolve Cookstyle 5.8 warnings - [@tas50](https://github.com/tas50)
* Fixes spec tests locally and on travis-ci
* Expand testing to the latest platformms - [@tas50](https://github.com/tas50)
* Fix Amazon Linux 201X and 2.x support - [@tas50](https://github.com/tas50)
* Fix opensuse failures - [@tas50](https://github.com/tas50)
* Remove support for EOL RHEL 5
* Require Chef Infra 13 or later

## 6.0.7 (2018-08-01)

* Optional creation of default configuration file 50-default.conf

## 6.0.6 (2018-08-25)

* Create working directory recursively

## 6.0.5 (2018-07-10)

* Remove Chefspec matchers that are autogenerated now
* Update specs to the latest platform versions
* Make sure all config files use the owner/group/mode attributes

## 6.0.4 (2018-01-16)

* Don't exclude any foodcritic rules
* Remove the need for apt cookbook in testing
* Remove omnios as a supported platform
* Simplify platform support in the metadata
* Update ignore files
* Require Chef 12.7+

## 6.0.3 (2018-01-12)

* Skip search if ['rsyslog']['server_search'] is empty
* Fix FC108 error

## 6.0.2 (2017-07-04)

* Updating README to reflect current Chef software version dependency and remove compat_resource cookbook dependency.
* Update kitchen configs and use delivery local mode instead of Rake
* Don’t fail parsing metadata.rb on older chef clients
* Simplify Travis config and fix ChefDK 2.0 failures
* Let permissions of template resources be configured through attributes
* Fix CHEF-19 - Add prefix new_resource to several properties

## 6.0.1 (2017-02-28)

* Fix Issue #126 multiple remote server configuration template which requires $ActionQueueFileName to be different for each remote server

## 6.0.0 (2017-02-23)

* Require Chef 12.5+ and remove dependency on compat_resource

## 5.1.0 (2016-12-30)

* Removed empty value from default custom_remote in attributes
* don't break if custom_remote is not set
* adding ability to override more options
* adding ability to set multiple log templates

## 5.0.1 (2016-12-06)

* Remove support for Ubuntu 10.04
* Simplify logic in the attributes file around Fedora
* Fix comment headers to be yard compatible

## 5.0.0 (2016-11-14)

* Make rsyslog only restart once if you define multiple file_input resources.
* Remove debugging log statement
* Require chef 12.1
* Require compat_resource 12.10+
* Remove chef 11 compat
* Remove support for arch
* Depend on the recent compat_resource cookbook

## v.4.0.1 (2016-07-20)

* PR #76 Validate the config file using `rsyslogd -N 1` via eherot
* PR #105 Use correct file name for remote.conf via mfenner
* PR #105 Add $LocalHostName directive via mfenner
* PR #105 Change directive `:fromhost-ip,!isequal,"127.0.0.1"` from using ~ to stop via mfenner
* PR #110 Add support for permitted peer via dastergon
* Add SUSE support
* Clean up travis configuration

## v.4.0.0 (2015-12-09)

* Removed support for Chef Solo. Since this cookbook now supports Chef 12+ only it makes far more sense to use Chef Zero (local mode) if a Chef server is not available.
* Removed yum from the Berksfile as it wasn't being used
* Fixed bad variables being passed in the file_input custom resource
* Added Chefspec matchers

## v.3.0.0 (2015-11-09)

* Breaking change: The file_input LWRP has been updated to be a Chef 12.5 custom_resource, with backwards compatibility to all Chef 12.x released provided by compat_resource. Additionally the 'source' and 'cookbook' attributes in the file_input resource have been renamed to 'template_source' and 'cookbook_source' to prevent failures.
* Helpers for determining the service provider on Ubuntu have been removed since Chef 12 does the right thing with Init, Upstart, and systemd.
* rsyslog::client no longer fails if there are no servers to forward logs to. Instead forwarding isn't configuring and a warning is written to the chef client log
* Fix broken templating of /etc/rsyslog.d/49-remote.conf when relp was enabled. Added testing to prevent future regressions here.
* Test Kitchen integration tests are now run via Travis so all PRs will be fully tested

## v.2.2.0 (2015-10-05)

* Add why-run support to the file_input LWRP
* Added support for rsyslog under systemd on Ubuntu 15.04+
* Added new attribute node['rsyslog']['custom_remote']. See readme for additional information
* Added source_url and issues_url metadata for Supermarket
* Fixed 49-relp.conf to honor logs_to_forward so it didn't just forward everything
* Updated contributing and testing docs
* Set the minimum supported Chef release to 11.0
* Added maintainers.toml and maintainers.md files
* Added Amazon Linux, Oracle, and Scientific Linux to the metadata
* Removed all pre-Ruby 1.9 hash rockets
* Updated development dependencies in the
* Fix a bad example attribute in the readme
* Updated Travis CI config to test on all modern Ruby releases

## v.2.1.0 (2015-07-22)

* Fixed minor markdown errors in the readme
* Allow the server to listen on both TCP and UDP. For both set node['rsyslog']['protocol'] to 'udptcp'
* Move the include for /etc/rsyslog.d/ to the very end of the rsyslog.conf config
* Added the ability to bind to a specific IP when running the server on UDP with node['rsyslog']['bind']
* Sync the comments in the rsyslog.conf file with the latest upstream rsyslog release
* Change emerg to log to :omusrmsg: *vs.* on modern rsyslog releases to avoid deprecation warnings

## v.2.0.0 (2015-05-18)

Note: This version includes several breaking changes for Ubuntu users. Be sure to take care when deploying these changes to production systems.

* 49-relp.conf now properly uses the list of servers discovered in the client recipe
* Fixed a typo that prevented file-input.conf from properly templating
* Added allow_non_local attribute to allow non-local messages. This defaults to false, which preserves the previous functionality
* The rsyslog directory permissions are now properly set using the user/group attributes instead of root/root
* Properly drop permissions on Ubuntu systems to syslog/syslog. Introduces 2 new attributes to control the user/group: priv_user and priv_group
* Remove logging to /dev/xconsole in 50-default.conf on Ubuntu systems. This is generally not something you'd want to do and produces error messages at startup.

## v.1.15.0 (2015-02-23)

* Change minimum supported Fedora release to 20 to align with the Fedora product lifecycle
* Add supports CentOS to metadata
* Update Rubocop and Test Kitchen dependencies to the latest versions
* Update Chefspec to 4.0
* Fix CentOS 5 support in the Kitchen config
* Fix rsyslog service notification in the file_input LWRP

## v.1.14.0 (2015-01-30)

* Don't attempt to use journald on Amazon Linux since Amazon Linux doesn't use systemd
* Fixed setting bad permissions on the working directory by using the rsyslog user/group variables.
* Fixed bad variable in the 49-relp.conf template that prevented Chef converges from completing.
* Removed the 'reload' action from the rsyslog service as newer rsyslog releases don't support reload.
* Updated Chefspecs to remove deprecation warnings and added additional tests.
* Removed node name from the comment block in the config files.
* Added a new file_input LWRP for defining configs.
* Added support for chef solo search cookbook.

## v1.13.0 (2014-11-25)

* Rsyslog's working directory is now an attribute and is set to the appropriate directory on RHEL based distros
* The working directory is now 0700 vs 0755 for additional security
* Add the ActionQueueMaxDiskSpace directive with a default of 1GB to prevent out of disk events during large buffering
* Updated RHEL / Fedora facilities to match those shipped by the distros
* Updated modules to match those used by journald (systemd) on Fedora 19+ and CentOS 7
* Added an attribute additional_directives to pass a hash of configs. This is currently only being used to pass directives necessary for journald support on RHEL 7 / Fedora 19+
* Added basic SUSE support
* Fixed logic that prevented Ubuntu from properly dropping privileges in Ubuntu >= 11.04
* Removed references to rsyslog v3 in the config template
* Added a chefignore file
* Updated Gemfile with newer releases of Test Kitchen, Rubocop, and Berkshelf
* Added Fedora 20, Debian 6/7, CentOS 7, and Ubuntu 12.04/14.04 to the Test Kitchen config
* Removed an attribute that was in the Readme twice
* Updated Travis to Ruby 2.1.1 to better match Chef 12
* Updated the Berksfile to point to Supermarket
* Refactored the specs to be more dry

## v1.12.2 (2014-02-28)

Fixing bug fix in rsyslog.conf

## v1.12.0 (2014-02-27)

* [COOK-4021] Allow specifying default templates for local and remote
* [COOK-4126] rsyslog cookbook fails restarts due to not using upstart

## v1.11.0 (2014-02-19)

### Bug

* [COOK-4256] - Fix syntax errors in default.conf on rhel

### New Feature

* [COOK-4022] - Add use_local_ipv4 option to allow selecting internal interface on cloud systems
* [COOK-4018] - rsyslog TLS encryption support

## v1.10.2

No change. Version bump for toolchain.

## v1.10.0

### New Feature

* [COOK-4021] - Allow specifying default templates for local and remote

### Improvement

* [COOK-3876] - Cater for setting rate limits

## v1.9.0

### New Feature

* [COOK-3736] - Support OmniOS

### Improvement

* [COOK-3609] - Add actionqueue to remote rsyslog configurations

### Bug

* [COOK-3608] - Add 50-default template knobs
* [COOK-3600] - SmartOS support

## v1.8.0

### Improvement

* [COOK-3573] - Add Test Kitchen, Specs, and Travis CI

### New Feature

* [COOK-3435] - Add support for relp

## v1.7.0

### Improvement

* [COOK-3253] - Enable repeated message reduction
* [COOK-3190] - Allow specifying which logs to send to remote server
* [COOK-2355] - Support forwarding events to more than one server

## v1.6.0

### New Feature

* [COOK-2831]: enable high precision timestamps

### Bug

* [COOK-2377]: calling node.save has adverse affects on nodes relying on a searched node's ohai attributes
* [COOK-2521]: rsyslog cookbook incorrectly sets directory ownership to rsyslog user
* [COOK-2540]: Syslogd needs to be disabled before starting rsyslogd on RHEL 5

### Improvement

* [COOK-2356]: rsyslog service supports status. Service should use it.
* [COOK-2357]: rsyslog cookbook copies in wrong defaults file on Ubuntu !9.10/10.04

## v1.5.0

* [COOK-2141] - Add `$PreserveFQDN` configuration directive

## v1.4.0

* [COOK-1877] - RHEL 6 support and refactoring

## v1.3.0

* [COOK-1189] - template change does not restart rsyslog on Ubuntu

This actually went into 1.2.0 with action `:reload`, but that change has been reverted and the action is back to `:restart`.

## v1.2.0

* [COOK-1678] - syslog user does not exist on debian 6.0 and ubuntu versions lower than 11.04
* [COOK-1650] - enable max message size configuration via attribute

## v1.1.0

Changes from COOK-1167:

* More versatile server discovery - use the IP as an attribute, or use search (see README)
* Removed cron dependency.
* Removed log archival; logrotate is recommended.
* Add an attribute to select the per-host directory in the log dir
* Works with Chef Solo now.
* Set debian/ubuntu default user and group. Drop privileges to `syslog.adm`.

## v1.0.0

* [COOK-836] - use an attribute to specify the role to search for instead of relying on the rsyslog['server'] attribute.
* Clean up attribute usage to use strings instead of symbols.
* Update this README.
* Better handling for chef-solo.
