#!/usr/bin/env bash

set -ex
APP_NAME=collector
APP_VERSION=1.0

ROOT=$(cd $(dirname ${0}) && pwd)
###############################################
# The following is build stage
###############################################
POM_FILE=${ROOT}/pom.xml

# mvn clean
mvn clean -e -f ${POM_FILE}

# mvn package
mvn package -e -f ${POM_FILE}


################################################
# The following is make rpm package
################################################
TARGET=${ROOT}/target

# unzip tar.gz package
tar -xzvf ${TARGET}/${APP_NAME}-${APP_VERSION}-bin.tar.gz -C ${TARGET}

# make rpm package
sh rpm/rpm-build.sh rpm/m-engine-collector.spec
