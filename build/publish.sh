#! /bin/bash
set -e

if [ -z "$1" ]
  then
    echo "Build number argument is required"
    echo "build.sh <build number>"
    exit 1
fi
build_number="$1"

# Load config
current_dir=`dirname $0`
. $current_dir/deploy-config/application.properties

package_name="$file_name$build_number$file_extension"

if [ ! -f $package_name ]; then
    echo "File not found: $package_name"
    exit 1
fi


# Upload file to S3
echo "Uploading $package_name to s3://$bucket_name"
aws s3 cp "$package_name" "s3://$bucket_name"

now=`date`

# Create version in EB
echo "Creating application version ($application_name)"
aws elasticbeanstalk create-application-version --region "$aws_region" --application-name "$application_name" --version-label "v$1" --description "Published at $now" --source-bundle "S3Bucket=$bucket_name,S3Key=$package_name" --no-auto-create-application --process

echo "Publish complete: $package_name"
