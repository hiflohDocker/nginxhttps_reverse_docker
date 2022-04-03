#!/bin/bash

x=true
i=0

if ! [[ -n "${SSLCERT_PATH}" ]] 
then 
    SSLCERT_PATH=/var/cert/live/$HOST0/
fi
if ! [[ -n "${SSLCERT_NAME}" ]] 
then 
    SSLCERT_NAME=fullchain.pem
fi
if ! [[ -n "${SSLCERT_KEY}" ]] 
then 
    SSLCERT_KEY=privkey.pem
fi
        

# HOST0=storage.gapp-hsg.eu
# HOST0_DEST=app
# HOST0_PORT=80
# HOST0_TYPE=nc
# HOST1=gitlab.gapp-hsg.eu
# HOST1_DEST=192.168.40.15
# HOST2=matrix.gapp-hsg.eu
# HOST2_DEST=matrix
# HOST3=onlyoffice.gapp-hsg.eu
# HOST3_DEST=only
# HOST4=speedtest.gap-hsg.eu
# HOST4_DEST=speedtest
while $x
do
host=HOST$i
host_dest=HOST${i}_DEST
host_type=HOST${i}_TYPE
host_port=HOST${i}_PORT
port=${!host_port}
type=${!host_type}
if [[ -n "${!host}" ]]
then
    if ! [[ -n "${!host_dest}" ]] 
    then
        echo "${!host} missing destination"
    else
        if ! [[ -n "${type}" ]] 
        then 
            type=default
        fi
        if ! [[ -n "${port}" ]] 
        then
            port=80
        fi
        echo "$i:${!host} ${!host_dest} ${type} ${port}"
        echo "s|hostname|${!host}|g" > /tmp/sed 
        echo "s|destination|${!host_dest}|g" >> /tmp/sed
        echo "s|destPort|${port}|g" >> /tmp/sed
        echo "s|certPath|${SSLCERT_PATH}|g" >> /tmp/sed
        echo "s|certName|${SSLCERT_NAME}|g" >> /tmp/sed
        echo "s|SSLCERT_KEY|${SSLCERT_KEY}|g" >> /tmp/sed
        sed -f /tmp/sed /start/${type}.conf > /etc/nginx/conf.d/${!host}.conf
    fi
else
    echo "break $i"
  x=false
fi

((i++))

done
cat -n /etc/nginx/conf.d/gitlab.gapp-hsg.eu.conf
ls -la /etc/nginx/conf.d/