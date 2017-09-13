# Install 1C Fresh Ubuntu (server and infobases)

# Accept 2 parameters:
# -a: fresh infobase name
# -p: solution infobase name

#Suppress interactive questions
export DEBIAN_FRONTEND=noninteractive

#Exit on error
set -e

while getopts ":a:p:" opt; do
  case $opt in
    a) fresh_base_name="$OPTARG"
    ;;
    p) solution_base_name="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

#Echo delimiter
function delimiter() {
	echo -e "\n---------------------------\n"
}

# Echo message
function message() {
	delimiter
	echo $1
	delimiter
}

# SET UP FRESH SERVER MANAGER INFOBASE
message "set up Fresh Server"

sudo service srv1cv83 restart

# create variable for server and console agents
mras='/opt/1C/v8.3/x86_64/ras'
mrac='/opt/1C/v8.3/x86_64/rac'

message "set up Fresh Server Infobase"

$mras cluster --daemon
# get cluster id
cluster=$(echo $($mrac cluster list) | cut -d':' -f 2 | cut -d' ' -f 2)
echo $cluster
# get server name
server=$(echo $($mrac cluster list) | cut -d':' -f 3 | cut -d' ' -f 2)
echo $server
# create infobase for fresh
$mrac infobase create --create-database --name=$fresh_base_name --dbms=PostgreSQL --db-server=$server --db-name=$fresh_base_name --locale=en_US --db-user=postgres --db-pwd=12345Qwerty --descr='1C Fresh Manager Service Infobase' --license-distribution=allow --cluster=$cluster >> infobase
# retrieving fresh infobase id
infobase1=$(cat infobase | cut -d':' -f 2 | cut -d' ' -f 2)
echo $infobase1
rm infobase
# create infobase for solution
$mrac infobase create --create-database --name=$solution_base_name --dbms=PostgreSQL --db-server=$server --db-name=$solution_base_name --locale=en_US --db-user=postgres --db-pwd=12345Qwerty --descr='1C Solution Infobase' --license-distribution=allow --cluster=$cluster >> infobase
# retrieving fresh infobase id
infobase2=$(cat infobase | cut -d':' -f 2 | cut -d' ' -f 2)
echo $infobase2
rm infobase
# getting sumary 
$mrac infobase summary list --cluster=$cluster
$mrac infobase info --infobase=$infobase1 --cluster=$cluster
$mrac infobase info --infobase=$infobase2 --cluster=$cluster

message "publish Fresh Service Infobase"

sudo chmod o+w /etc/apache2/1cfresh_a
sudo cp /fresh-install/conf/etc/apache2/1cfresh_a/sm.conf "/etc/apache2/1cfresh_a/$fresh_base_name.conf"
sudo sed -i "s/<--ibname-->/$fresh_base_name/g" "/etc/apache2/1cfresh_a/$fresh_base_name.conf"
sudo chmod o-w /etc/apache2/1cfresh_a

sudo chmod o+w /etc/apache2/1cfresh_int
sudo cp /fresh-install/conf/etc/apache2/1cfresh_int/sm.conf "/etc/apache2/1cfresh_int/$fresh_base_name.conf"
sudo sed -i "s/<--ibname-->/$fresh_base_name/g" "/etc/apache2/1cfresh_int/$fresh_base_name.conf"
sudo chmod o-w /etc/apache2/1cfresh_int

sudo mkdir -p /var/www/1cfresh/a/$fresh_base_name/
sudo mkdir -p /var/www/1cfresh/int/$fresh_base_name/

sudo chmod o+w "/var/www/1cfresh/a/$fresh_base_name"
sudo cp /fresh-install/conf/var/www/1cfresh/a/sm/default.vrd "/var/www/1cfresh/a/$fresh_base_name/default.vrd"
sudo sed -i "s/<--ibname-->/$fresh_base_name/g" "/var/www/1cfresh/a/$fresh_base_name/default.vrd"
sudo sed -i "s/<--server_name-->/$server/g" "/var/www/1cfresh/a/$fresh_base_name/default.vrd"
sudo chmod o-w "/var/www/1cfresh/a/$fresh_base_name"

sudo chmod o+w "/var/www/1cfresh/int/$fresh_base_name"
sudo cp /fresh-install/conf/var/www/1cfresh/int/sm/default.vrd "/var/www/1cfresh/int/$fresh_base_name/default.vrd"
sudo sed -i "s/<--ibname-->/$fresh_base_name/g" "/var/www/1cfresh/int/$fresh_base_name/default.vrd"
sudo sed -i "s/<--server_name-->/$server/g" "/var/www/1cfresh/int/$fresh_base_name/default.vrd"
sudo chmod o-w "/var/www/1cfresh/int/$fresh_base_name"

message "publish Solution Infobase"

sudo chmod o+w /etc/apache2/1cfresh_a
sudo cp /fresh-install/conf/etc/apache2/1cfresh_a/app.conf "/etc/apache2/1cfresh_a/$solution_base_name.conf"
sudo sed -i "s/<--ibname-->/$solution_base_name/g" "/etc/apache2/1cfresh_a/$solution_base_name.conf"
sudo chmod o-w /etc/apache2/1cfresh_a

sudo chmod o+w /etc/apache2/1cfresh_int
sudo cp /fresh-install/conf/etc/apache2/1cfresh_int/app.conf "/etc/apache2/1cfresh_int/$solution_base_name.conf"
sudo sed -i "s/<--ibname-->/$solution_base_name/g" "/etc/apache2/1cfresh_int/$solution_base_name.conf"
sudo chmod o-w /etc/apache2/1cfresh_int

sudo mkdir -p /var/www/1cfresh/a/$solution_base_name/
sudo mkdir -p /var/www/1cfresh/int/$solution_base_name/

sudo chmod o+w "/var/www/1cfresh/a/$solution_base_name"
sudo cp /fresh-install/conf/var/www/1cfresh/a/app/default.vrd "/var/www/1cfresh/a/$solution_base_name/default.vrd"
sudo sed -i "s/<--ibname-->/$solution_base_name/g" "/var/www/1cfresh/a/$solution_base_name/default.vrd"
sudo sed -i "s/<--server_name-->/$server/g" "/var/www/1cfresh/a/$solution_base_name/default.vrd"
sudo chmod o-w "/var/www/1cfresh/a/$solution_base_name"

sudo chmod o+w "/var/www/1cfresh/int/$solution_base_name"
sudo cp /fresh-install/conf/var/www/1cfresh/int/app/default.vrd "/var/www/1cfresh/int/$solution_base_name/default.vrd"
sudo sed -i "s/<--ibname-->/$solution_base_name/g" "/var/www/1cfresh/int/$solution_base_name/default.vrd"
sudo sed -i "s/<--server_name-->/$server/g" "/var/www/1cfresh/int/$solution_base_name/default.vrd"
sudo chmod o-w "/var/www/1cfresh/int/$solution_base_name"

message "Infobases are published"

sudo ufw allow 234
sudo ufw 22
sudo ufw allow 1541
sudo ufw allow 1560
sudo ufw enable
sudo ufw status

