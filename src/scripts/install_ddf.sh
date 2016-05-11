#!/usr/bin/env bash

declare SCRIPT_DIR
declare ASSET_DIR
declare MEDIA_DIR
declare DEST_DIR
declare VERSION

declare -x darwin=false
declare -x linux=false
declare -x RUN=false
declare -x SERVICE=false



detectOS() {
  # OS specific support (must be 'true' or 'false').
  case "`uname`" in
    Darwin*)
      darwin=true
      ;;
    Linux*)
      linux=true
      ;;
    *)
      echo -e "\n`uname` is not currently supported, attempting to run with settings for linux\n"
      linux=true
  esac
}

usage() {
    echo "Usage: `basename $0` [-rsh] [-d install dir]"
    exit 2
}

check_dirs() {
  echo "Checking for media source directory: ${MEDIA_DIR}"
  if [ ! -d "${MEDIA_DIR}" ]; then
    echo "Media Directory: ${MEDIA_DIR} does not exist"
    exit 3
  fi

  echo "Checking for destination directory: ${DEST_DIR}"
  if [ ! -d "${DEST_DIR}" ]; then
    echo "Creating installation directory: ${DEST_DIR}"
    mkdir -p ${DEST_DIR}
  fi
}

init() {
  detectOS

  # Set SCRIPT_DIR based on environment
  if $linux; then
  	SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
    DEST_DIR=/opt/ddf
  elif $darwin; then
  	#For Darwin, check for greadlink
  	if type -p greadlink; then
  		SCRIPT_DIR="$(dirname "$(greadlink -f "$0")")"
  	else
  		echo -e "\n greadlink is not available in the PATH\n\
  			This is provided on OSX by coreutils\n\
  			coreutils can be installed through homebrew by running\n\
  			'brew install coreutils'\n\
  			For more information on homebrew, see: http://brew.sh"
  		echo -e "\nAttempting fallback method...\n"

  		SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
      DEST_DIR=/usr/local/share/ddf
  	fi
  fi

  ASSET_DIR=$(dirname ${SCRIPT_DIR})
  MEDIA_DIR=${ASSET_DIR}/media
  VERSION=$(cat ${SCRIPT_DIR}/DDF_VERSION)

  while [ "$1" != "" ]; do
    case $1 in
        -d | --destination )
            shift
            DEST_DIR="$1"
            ;;
        -r | --run )
            RUN=true
            ;;
        -s | --service )
            SERVICE=true
            ;;
        -h | --help )
            usage
            exit 2
            ;;
        * )
            usage
    esac
    shift
  done

  check_dirs
}

# Unpacks the ddf distribution
unpack() {
  echo "Unpacking ${MEDIA_DIR}/ddf-${VERSION}.zip to ${DEST_DIR}"
  unzip -qq ${MEDIA_DIR}/ddf-${VERSION}.zip -d ${DEST_DIR}/
  DDF_HOME=${DEST_DIR}/ddf-${VERSION}
  echo "Adding DDF Home: ${DDF_HOME} to /etc/environment"
  echo "export DDF_HOME=${DDF_HOME}" >> /etc/environment
  source /etc/environment
}

run() {
  echo "Starting container from ${DDF_HOME}"
  ${DDF_HOME}/bin/start
}

# TODO: Add steps to install as a service
service() {
  echo "Service Installation Not Implemented Yet!"
}


main() {
  init $@

  unpack

  if [ "${RUN}" = true ]; then
    run
  fi

  if [ "${SERVICE}" = true ]; then
    service
  fi
}

main $@
