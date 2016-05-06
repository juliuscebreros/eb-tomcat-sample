#! /bin/sh -e
# This script deploys the application package to Elastic Beanstalk

set -e

# Load config
current_dir=`dirname $0`
. $current_dir/deploy-config/application.properties


if [ -z "$1" ]
  then
    echo "Build number argument is required"
    echo "deploy.sh <build number> <environment>"
    exit 1
fi
version_label="v$1"

if [ -z "$2" ]
  then
    echo "Environment name argument is required"
    echo "deploy.sh <build number> <environment name>"
    exit 1
fi
environment="$2"


echo "Beginning deployment of $version_label to $environment"

aws elasticbeanstalk update-environment --application-name "$application_name" --environment-name "$environment" --version-label "$version_label"

echo "Deployment complete"
