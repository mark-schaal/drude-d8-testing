#!/usr/bin/env bash

# Abort if anything fails
set -e

#-------------------------- Settings --------------------------------

# Get project root directory and set docroot
# We rely on an existing Git repo in the project folder.
# If there is no git repo, then just initialize an empty one in the project root with `git init`.
PROJECT_ROOT=$(git rev-parse --show-toplevel); if [[ -z $PROJECT_ROOT  ]]; then exit -1; fi
DOCROOT='docroot'
DOCROOT_PATH=$PROJECT_ROOT/$DOCROOT
# Set to the appropriate site directory
SITE_DIRECTORY='default'
SITEDIR_PATH="${DOCROOT_PATH}/sites/${SITE_DIRECTORY}"
# Set to the appropriate site domain
SITE_DOMAIN='drupal8.drude'

#-------------------------- END: Settings --------------------------------


#-------------------------- Helper functions --------------------------------

# Console colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
NC='\033[0m'

echo-red () { echo -e "${red}$1${NC}"; }
echo-green () { echo -e "${green}$1${NC}"; }
echo-yellow () { echo -e "${yellow}$1${NC}"; }

if_failed ()
{
	if [ ! $? -eq 0 ]; then
		if [[ "$1" == "" ]]; then msg="an error occured"; else msg="$1"; fi
		echo-red "$msg";
		exit 1;
	fi
}

# Copy a settings file.
# Skips if the destination file already exists.
# @param $1 source file
# @param $2 destination file
copy_settings_file()
{
  local source=${1}
  local dest=${2}

  if [[ ! -f $dest ]]; then
    echo-green "Copying ${dest}..."
    cp $source $dest
  else
    echo-yellow "${dest} already in place."
  fi
}

#-------------------------- END: Helper functions --------------------------------


#-------------------------- Functions --------------------------------

# Initialize local settings files
init_settings ()
{
  echo-green "Initializing local project configuration..."
  # Copy from settings templates
  copy_settings_file "${PROJECT_ROOT}/docker-compose.yml.dist" "${PROJECT_ROOT}/docker-compose.yml"
  copy_settings_file "${SITEDIR_PATH}/example.settings.local.php" "${SITEDIR_PATH}/settings.local.php"
  copy_settings_file "${PROJECT_ROOT}/tests/behat/behat.yml.dist" "${PROJECT_ROOT}/tests/behat/behat.yml"
}

# Set file/folder permissions
file_permissions ()
{
  echo-green "Setting file/folder permissions..."
  mkdir -p $DOCROOT_PATH/sites/$SITE_DIRECTORY/files
  chmod 777 $DOCROOT_PATH/sites/$SITE_DIRECTORY/files
}

# Install site
site_install ()
{
  echo-green "Installing site..."
  cd $DOCROOT_PATH && \
  dsh exec drush8 si -y
}

#-------------------------- END: Functions --------------------------------


#-------------------------- Execution --------------------------------

init_settings
#file_permissions

dsh reset
# Give MySQL some time to start
echo-green "Waiting 5s for MySQL to start..."; sleep 5

time site_install

echo-green "Add ${SITE_DOMAIN} to your hosts file (/etc/hosts), e.g.:"
echo-green "192.168.10.10  ${SITE_DOMAIN}"
echo-green "Alternatively configure wildcard DNS resolution and never edit the hosts file again! Instructions:"
echo-green "https://github.com/blinkreaction/boot2docker-vagrant#dns"
echo-green "Open http://${SITE_DOMAIN} in your browser to verify the setup."

#-------------------------- END: Execution --------------------------------
