#!/bin/bash

WT='\033[1;37m'
GR='\033[0;32m'
NC='\033[0m'

REPO='https://github.com/NateElliott/DLP.git'
BRAN='dev'


printf "\n${WT}Installing DLP${NC}\n"
read -p "$(echo -e "Enter branch:")" BRAN

printf "... ${GR}Preparing to install${NC}\n"
apt-get -qq update

printf "... ${GR}Installing Git${NC}\n"
apt-get -qq install git

printf "... ${GR}Installing virtualenv${NC}\n"
apt-get -qq install python-virtualenv

printf "... ${GR}Preparing virtualenv${NC}\n"
virtualenv -q -p python3 backbone

printf "... ${GR}Installing Django${NC}\n"
backbone/bin/pip -q install Django

printf "... ${GR}Cloning branch($BRAN)${NC}\n"
git clone -b $BRAN -q $REPO


touch runserver.sh
cat <<EOT >> runserver.sh
#!/bin/bash
backbone/bin/python DLP/playground/manage.py runserver
EOT


touch refresh.sh
cat <<EOT >> refresh.sh
REPO=$REPO
BRAN=$BRAN
printf "\n${WT}Refreshing local development environment${NC}\n"

printf "... ${GR}Flushing DLP(core)${NC}\n"
rm -rf DLP/

printf "... ${GR}Cloning DLP(core)${NC}\n"
git clone -b $BRAN -q $REPO
EOT


touch uninstall.sh
cat <<EOT >> uninstall.sh
printf "\n${WT}Removing DLP${NC}\n"
printf "... ${GR}Removing backbone${NC}\n"
rm -rf backbone/
printf "... ${GR}Removing DLP(core)${NC}\n"
rm -rf DLP/
printf "... ${GR}Cleaning up...${NC}\n"
rm uninstall.sh
rm refresh.sh
rm runserver.sh
EOT

chmod 777 runserver.sh
chomd 777 refresh.sh
chmod 777 uninstall.sh

printf "${WT}Install complete!${NC}\n\n"

printf "Use: ${GR}sudo ./runserver.sh${NC} to start local development server.\n"
printf "Use: ${GR}sudo ./refresh.sh${NC} to refresh local development server.\n"
printf "Use: ${GR}sudo ./uninstall.sh${NC} to remove local development environment.\n\n"
