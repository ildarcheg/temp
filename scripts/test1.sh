# create variable for server and console agents
mras='/opt/1C/v8.3/x86_64/ras'
mrac='/opt/1C/v8.3/x86_64/rac'

$mras cluster --daemon
# get cluster id
cluster=$(echo $($mrac cluster list) | cut -d':' -f 2 | cut -d' ' -f 2)
echo $cluster
# get server name
server=$(echo $($mrac cluster list) | cut -d':' -f 3 | cut -d' ' -f 2)
echo $server
