module RsyslogUtils

  def rsyslog_servers
    # On Chef Solo, we use the node['rsyslog']['server_ip'] attribute, and on
    # normal Chef, we leverage the search query.
    if Chef::Config[:solo]
      if node['rsyslog']['server_ip']
        rsyslog_servers = Array(node['rsyslog']['server_ip'])
      else
        Chef::Application.fatal!("Chef Solo does not support search. You must set node['rsyslog']['server_ip']!")
      end
    else
      results = search(:node, node['rsyslog']['server_search']).map do |server|
        ipaddress = server['ipaddress']
        # If both server and client are on the same cloud and local network, they may be
        # instructed to communicate via the internal interface by enabling `use_local_ipv4`
        if node['rsyslog']['use_local_ipv4'] && server.attribute?('cloud') && server['cloud']['local_ipv4']
          ipaddress = server['cloud']['local_ipv4']
        end
        ipaddress
      end
      rsyslog_servers = Array(node['rsyslog']['server_ip']) + Array(results)
    end
    return rsyslog_servers
  end
end

class Chef::Recipe ; include RsyslogUtils ; end
class Chef::Resource ; include RsyslogUtils ; end
class Chef::Resource::Template ; include RsyslogUtils ; end
