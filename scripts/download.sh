# Download 1C Fresh sources

source util.sh

message "install Curl"

sudo apt-get  --yes --force-yes install curl

message "download sources"

sudo curl -O http://61.28.226.190/fresh-install-64.zip
sudo unzip fresh-install-64.zip

message "copy sources to /fresh-install"

sudo cp -a fresh-install-64/* /fresh-install/

message "delete sources"

rm -fr fresh-install-64
rm fresh-install-64.zip

message "ALL DONE"
