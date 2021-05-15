sudo cat << EOF > /etc/mysql/mariadb.conf.d/90-enable-event-scheduler.cnf
[mariadb]
event_scheduler=ON
EOF
