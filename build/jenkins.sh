#!/bin/bash

# Jenkins specific "bridge", edits the properties file to point to the latest build
# Uploads the build to S3 first

FILE=$(ls /home/jenkins/build/workspace/$1/target/ics*.war)
WAR_FILE_NAME=$(basename $FILE)

echo "File is: $FILE"

GIT_ROOT_FOLDER=/home/jenkins/build/eb-alarms-engine
WRAPPER_PROPERTIES_FILE=${GIT_ROOT_FOLDER}/build/deploy-config/application.properties

echo "Found war file: $WAR_FILE_NAME"

git_commit() {
        sleep 2
        cd "$GIT_ROOT_FOLDER"
        sleep 2
        git add . --all
        sleep 2
        git commit -m "Build From Jenkins. Update ${WAR_FILE_NAME}"
        sleep 2
        git push origin master
}

echo "Upload to S3"
aws s3 cp "$FILE" s3://ics-bamboo-builds

cd "$GIT_ROOT_FOLDER"
git pull
sed -i "s/.*$2.*/$2=\"$WAR_FILE_NAME\"/" "$WRAPPER_PROPERTIES_FILE"

echo "PUSHING TO WRAPPER"
git_commit
