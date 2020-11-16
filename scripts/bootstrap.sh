#!/bin/bash

# Installing apache on AWS Linux
yum -y install httpd
systemctl enable httpd
systemctl start httpd
