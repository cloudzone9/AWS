# Create a VPC
# VPC => Region 
aws ec2 create-vpc --cidr-block 10.10.0.0/16
#vpc-05ec401b6bf355d32

# Create atleast two subnets
# Subnet => AZ 
aws ec2 create-subnet --cidr-block 10.10.1.0/24 --availability-zone us-east-1a --vpc-id vpc-05ec401b6bf355d32
#subnet-080d5d5b2702468db

aws ec2 create-subnet --cidr-block 10.10.2.0/24 --availability-zone us-east-1b --vpc-id vpc-05ec401b6bf355d32
#subnet-0bf05865ccfb64cba

aws ec2 create-subnet --cidr-block 10.10.3.0/24 --availability-zone us-east-1c --vpc-id vpc-05ec401b6bf355d32
#subnet-00e6798266ec66570

## Create Internet Gateway
aws ec2 create-internet-gateway 
#igw-0f841f314f14447f0

## Attach Internet gateway to VPC
aws ec2 attach-internet-gateway --internet-gateway-id igw-0f841f314f14447f0 --vpc-id vpc-05ec401b6bf355d32

## Create Route Table
aws ec2 create-route-table --vpc-id vpc-05ec401b6bf355d32
#rtb-0228d27bdb9ff21e3

## Create Route 
aws ec2 create-route --destination-cidr-block 0.0.0.0/0 --route-table-id rtb-0228d27bdb9ff21e3 --gateway-id igw-0f841f314f14447f0

##Associate Route table
aws ec2 associate-route-table --route-table-id rtb-0228d27bdb9ff21e3 --subnet-id subnet-080d5d5b2702468db
#rtbassoc-062668b5227c67e72

aws ec2 associate-route-table --route-table-id rtb-0228d27bdb9ff21e3 --subnet-id subnet-0bf05865ccfb64cba
#rtbassoc-073850310e5b98f46

aws ec2 associate-route-table --route-table-id rtb-0228d27bdb9ff21e3 --subnet-id subnet-00e6798266ec66570
#rtbassoc-0d0289937509a30f3

## Create a DB Subnet Group
aws rds create-db-subnet-group --db-subnet-group-name "rdssubnet" --db-subnet-group-description "This is rds subnet group" --subnet-ids "subnet-080d5d5b2702468db" "subnet-0bf05865ccfb64cba" --tags "Key=Name,Value=rds group"

# Create Security Group
aws ec2 create-security-group --description "Ansible Security Group" --group-name "Ansible" --vpc-id vpc-05ec401b6bf355d32
#sg-0d791d43368cabe50

# Create Security Group Ingress Rules
aws ec2 authorize-security-group-ingress --group-id sg-0d791d43368cabe50 --protocol tcp --port 22 --cidr 0.0.0.0/0 

aws ec2 authorize-security-group-ingress --group-id sg-0d791d43368cabe50 --protocol tcp --port 80 --cidr 0.0.0.0/0

# Create EC2 Instance 
aws ec2 run-instances --image-id ami-0a313d6098716f372 --instance-type t2.micro --count 1 --subnet-id subnet-080d5d5b2702468db --security-group-ids sg-0d791d43368cabe50 --key-name krr --associate-public-ip-address 
