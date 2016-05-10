#! /bin/bash
set -e

temp_dir="temp-build-dir"

if [ -z "$1" ]
  then
    echo "Build number argument is required"
    echo "build.sh <build number>"
    exit 1
fi
build_number="$1"

echo "Beginning build: $build_number"

# Load config
current_dir=`dirname $0`
. $current_dir/deploy-config/application.properties


# Prepare working directory
if [ -d "$temp_dir" ];
  then
    rm -rf $temp_dir
fi
mkdir $temp_dir

# Download from S3
echo "Downloading artifact from s3://$bucket_name/$alarm_war"
aws s3 cp "s3://$bucket_name/$alarm_war" "$temp_dir/alarms-engine.war"
aws s3 cp "s3://$bucket_name/$scheduled_war" "$temp_dir/alarm-aggregator.war"

# create a ROOT war file
# jar -cvf $temp_dir/ROOT.war cron.yaml
touch $temp_dir/index.html
jar -cvf $temp_dir/ROOT.war cron.yaml
rm $temp_dir/index.html


# copy ebextensions folder to
mkdir $temp_dir/.ebextensions
cp -r .ebextensions/ $temp_dir/

#copy config to ebextensions
cp ./build/deploy-config/*.properties $temp_dir/.ebextensions/
cp ./build/deploy-config/logback.xml $temp_dir/.ebextensions/logback.xml

#cp cron.yaml $temp_dir/cron.yaml


# Create a zip package
pushd $temp_dir >/dev/null
package_name="$file_name$build_number$file_extension"
zip -rq "$package_name" .
popd >/dev/null

# Move zip to the current location
mv "$temp_dir/$package_name" "./$package_name"

# Clean up
rm -rf $temp_dir

echo "Build complete: $package_name"
