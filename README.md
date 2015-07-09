# cloudflare_script
1. create cloudflare user
    Home dir /mnt/logs/cloudflare

2. This needs the following cron job for the cloudflare user
* * * * * /mnt/logs/cloudflare/get_cloudflare_logs.sh

logs
- incoming
- processing
- outgoing
drop stuff into incoming.. it will pick it up after way 30 seconds since last access time
move it into processing
where something else can pick it up -=> outgoing
then in outgoing .. after 7 days => rm
but if miss data
we just do mv /logs/outgoing* /logs/incoming
