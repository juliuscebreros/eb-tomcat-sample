#!/bin/bash

aws --profile ics-qa elasticbeanstalk create-environment \
  --application-name ICS-API \
  --environment-name ICS-DEV-5 \
  --solution-stack-name "64bit Amazon Linux 2016.03 v2.1.1 running Tomcat 8 Java 8" \
  --version-label v5 \
  --option-settings file://options.json \
  --tier Name=Worker,Type=SQS/HTTP,Version=1.0
