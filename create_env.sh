#!/bin/bash

aws --profile ics-qa elasticbeanstalk create-environment \
  --application-name ICS-API \
  --environment-name ICS-DEV-2 \
  --solution-stack-name "64bit Amazon Linux 2016.03 v2.1.1 running Tomcat 8 Java 8" \
  --version-label v4
