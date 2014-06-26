@test "the server is configured" {
  test /etc/rsyslog.d/34-server.conf
}

@test "the remote.conf does not exist" {
  test ! -f /etc/rsyslog.d/remote.conf
}
