#!/bin/bash
# Tested on AWS ubuntu, redhat and amazon linux

# In order for this to work, make sure you create an IAM role and assign it to the launch instance. The relavant line:
# arn:aws:s3:::chef-lepages/* specifies the name of the S3 bucket. In this case, the S3 bucket is named "chef-lepages"
# 
# {
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Effect": "Allow",
#            "Action": [
#                "s3:GetObject",
#                "s3:ListBucket"
#            ],
#            "Resource": [
#                "arn:aws:s3:::chef-lepages/*"
#            ]
#        }
#    ]
#}

#install chef omnibus client
true && curl -L https://www.opscode.com/chef/install.sh | bash
mkdir /etc/chef

#make sure it's an amazon instance os
if [[ $(dmidecode | grep -i amazon) ]]
then
  os=$(uname -a)
  echo $os
  if grep -qv "amzn" <<< "$os"	#anything but amazon linux
    #aws tools
    curl -O https://bootstrap.pypa.io/get-pip.py
    python get-pip.py
    pip install awscli
    #instance region for running aws s3
    region=`curl -s 169.254.169.254/latest/meta-data/placement/availability-zone`
    region=${region::-1}
    export AWS_DEFAULT_REGION=$region
  fi
fi


#copy chef solo and node files
aws s3 cp s3://chef-lepages/linux/node.json /etc/chef
aws s3 cp s3://chef-lepages/linux/solo.rb /etc/chef

#if run from cloud-init userdata, root home directory is not yet set to /root when this is run
export HOME=/root

#execute solo chef run
chef-solo -j /etc/chef/node.json -c /etc/chef/solo.rb --recipe-url https://s3-us-west-2.amazonaws.com/chef-lepages/linux/mcafee-linux-0.1.8.tar.gz
