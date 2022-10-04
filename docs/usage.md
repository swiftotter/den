# Dem Usage

## Common Commands

Launch a shell session within the project environment's `php-fpm` container:

    den shell

Stopping a running environment:

    den env stop

Starting a stopped environment:

    den env start

Import a database (if you don't have `pv` installed, use `cat` instead):

    pv /path/to/dump.sql.gz | gunzip -c | den db import

Monitor database processlist:

    watch -n 3 "den db connect -A -e 'show processlist'"

Tail environment nginx and php logs:

    den env logs --tail 0 -f nginx php-fpm php-debug

Tail the varnish activity log:

    den env exec -T varnish varnishlog

Flush varnish:

     den env exec -T varnish varnishadm 'ban req.url ~ .' 

Connect to redis:

    den redis

Flush redis completely:

    den redis flushall

Run redis continous stat mode

    den redis --stat

Remove volumes completely:

    den env down -v

## Further Information

Run `den help` and `den env -h` for more details and useful command information.
