## Version 2020/12/09
# make sure that your dns has a cname set for nextcloud
# assuming this container is called "swag", edit your nextcloud container's config
# located at /config/www/nextcloud/config/config.php and add the following lines before the ");":
#  'trusted_proxies' => ['swag'],
#  'overwrite.cli.url' => 'https://nextcloud.your-domain.com/',
#  'overwritehost' => 'nextcloud.your-domain.com',
#  'overwriteprotocol' => 'https',
#
# Also don't forget to add your domain name to the trusted domains array. It should look somewhat like this:
#  array (
#    0 => '192.168.0.1:444', # This line may look different on your setup, don't modify it.
#    1 => 'nextcloud.your-domain.com',
#  ),

server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name s.ppag.ga;

#    include /config/nginx/ssl.conf;

# Certificates
ssl_certificate /var/cert/live/storage.gapp-hsg.eu/fullchain.pem;
ssl_certificate_key /var/cert/live/storage.gapp-hsg.eu/privkey.pem;


    client_max_body_size 0;

    location / {
#        include /config/nginx/proxy.conf;
        resolver 127.0.0.11 valid=30s;
        set $upstream_app app;
        set $upstream_port 80;
        set $upstream_proto http;
#        proxy_pass $upstream_proto://$upstream_app:$upstream_port;
	proxy_pass http://yourls;

        proxy_max_temp_file_size 2048m;
    }
}
