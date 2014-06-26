@test "the server is configured for PostgreSQL" {
  test /etc/rsyslog.d/35-postgresql.conf
}

@test "the 35-server-per-host.conf does not exist" {
  test ! -f /etc/rsyslog.d/35-server-per-host.conf
}

@test "PostgreSQL records logging activity" {
  su -c true # Generate activity.
  run psql -q -t -c "SELECT * FROM systemevents" Syslog
  [ "$status" -eq 0 ]
  [ -n "$output" ]
}
