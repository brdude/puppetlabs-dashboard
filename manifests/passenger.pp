# Class: dashboard::passenger
#
# This class configures parameters for the puppet-dashboard module.
#
# Parameters:
#   [*passenger_install*]
#     - Install passenger using puppetlabs/passenger module or assume it is
#       installed by 3rd party
#   [*dashboard_site*]
#     - The ServerName setting for Apache
#
#   [*dashboard_port*]
#     - The port on which puppet-dashboard should run
#
#   [*dashboard_config*]
#     - The Dashboard configuration file
#
#   [*dashboard_root*]
#     - The path to the Puppet Dashboard library
#
#   [*rails_base_uri*]
#     - The base URI for the application
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dashboard::passenger (
  $passenger_install,
  $dashboard_site,
  $dashboard_port,
  $dashboard_config,
  $dashboard_root,
  $rails_base_uri,
  $dashboard_service,
  $dashboard_package,
) inherits dashboard {

  if $passenger_install {
    require ::passenger
  }
  include apache
  
  service { $dashboard_service:
    ensure     => stopped,
    enable     => false,
    hasrestart => true,
    require    => Package[$dashboard_package],
  }

  apache::vhost { $dashboard_site:
    port              => $dashboard_port,
    priority          => '50',
    docroot           => "${dashboard_root}/public",
    servername        => $dashboard_site,
    options           => 'None',
    override          => 'AuthConfig',
    error_log         => true,
    access_log        => true,
    access_log_format => 'combined',
    custom_fragment   => "RailsBaseURI ${rails_base_uri}",
  }
}
