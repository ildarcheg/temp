solution_base_name=acs
server=u-test1

sudo chmod o+w "/var/www/1cfresh/int/$solution_base_name"
sudo cp /fresh-install/conf/var/www/1cfresh/int/app/default.vrd "/var/www/1cfresh/int/$solution_base_name/default.vrd"
sudo sed -i "s/<--ibname-->/$solution_base_name/g" "/var/www/1cfresh/int/$solution_base_name/default.vrd"
sudo sed -i "s/<--server_name-->/$server/g" "/var/www/1cfresh/int/$solution_base_name/default.vrd"
