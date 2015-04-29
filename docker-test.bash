#!/bin/bash

# Simple script to run tests of specific module in docker environment
#
# Usage:
#     docker_test <odoo_version> <repository> <branch> <module> [<module> ...] 
#
# Where:
#     odoo_version - version of Odoo to test repository on. example: 8.0
#     repository   - url of git repository to test.
#     branch       - branch of repository to be tested
#     module       - module to be tested. if repository is single-module
#                    then it should be just name of repository


SCRIPT=$0;
SCRIPT_NAME=`basename $SCRIPT`;
F=`readlink -f $SCRIPT`;  # full script path;
BASEDIR=`dirname $F`

ODOO_HELPER=$BASEDIR/odoo-helper.bash

# DIRS
DOWNLOADS_DIR=$BASEDIR/downloads;
ADDONS_DIR=$BASEDIR/additional_addons;


set -e;

# odoo_helper <version>
function odoo_helper {
    local version=$1;
    shift;
    $ODOO_HELPER --addons_dir $ADDONS_DIR/$version --downloads_dir $DOWNLOADS_DIR/$version --use_copy $@;
}

# test_module <odoo_version> <repository> <branch> <module> [<module> ...]
function test_module {
    local VERSION=$1;
    local REPOSITORY=$2;
    local REPO_BRANCH=$3;
    shift; shift; shift;

    # fetch all modules from repository
    odoo_helper $VERSION fetch_module -r $REPOSITORY -b $REPO_BRANCH;

    local TEST_DB_NAME="odoo_test_db_$VERSION";
    local ODOO_START_CMD="./bin/boot start --workers=0 --database=$TEST_DB_NAME --stop-after-init";
    local MODULE_TEST_CMD="echo 'start testing modules'";

    # Create command to test specified modules
    local module=;
    for module in $@; do
        MODULE_TEST_CMD="$MODULE_TEST_CMD; $ODOO_START_CMD --init=$module --log-level=warn; $ODOO_START_CMD --update=$module --log-level=test --test-enable";
    done

    local TEST_CMD="sudo -u odoo -- dropdb -h db -U pg --if-exists $TEST_DB_NAME";
    TEST_CMD="$TEST_CMD; sudo -u odoo -- createdb -h db -U pg $TEST_DB_NAME";
    TEST_CMD="$TEST_CMD; $ODOO_START_CMD --init=mail --log-level=warn";
    TEST_CMD="$TEST_CMD; $MODULE_TEST_CMD";
    local DOCKER_CMD="docker-compose run --rm o7 eval \"$TEST_CMD\"";

    echo "Running test command:";
    echo "    $DOCKER_CMD";
    eval $DOCKER_CMD;

}


test_module $@;
