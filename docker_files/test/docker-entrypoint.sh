#!/bin/sh

/usr/local/bin/nginx-exporter -nginx.scrape-uri http://127.0.0.1:8091/stub_status -web.listen-address :9114 &

exec "$@"