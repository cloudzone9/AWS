# Create a VPC
# VPC => Region 
aws ec2 create-vpc --cidr-block 10.10.0.0/16
#vpc-0ce92f05e74948458

# Create atleast two subnets
# Subnet => AZ 
aws ec2 create-subnet --cidr-block 10.10.1.0/24 --availability-zone us-east-1a --vpc-id vpc-0ce92f05e74948458
#subnet-0e7fda3d74b05b042

aws ec2 create-subnet --cidr-block 10.10.2.0/24 --availability-zone us-east-1b --vpc-id vpc-0ce92f05e74948458
#subnet-0b3786d14f6f667c7

aws ec2 create-subnet --cidr-block 10.10.3.0/24 --availability-zone us-east-1c --vpc-id vpc-0ce92f05e74948458
#subnet-0bd67798ea419a9f3

## Create Internet Gateway
aws ec2 create-internet-gateway 
#igw-0486aaa116a18b5de

## Attach Internet gateway to VPC
aws ec2 attach-internet-gateway --internet-gateway-id igw-0486aaa116a18b5de --vpc-id vpc-0ce92f05e74948458

## Create Route Table
aws ec2 create-route-table --vpc-id vpc-0ce92f05e74948458
#rtb-0b297578e956e25cf

## Create Route 
aws ec2 create-route --destination-cidr-block 0.0.0.0/0 --route-table-id rtb-0b297578e956e25cf --gateway-id igw-0486aaa116a18b5de

##Associate Route table
aws ec2 associate-route-table --route-table-id rtb-0b297578e956e25cf --subnet-id subnet-0e7fda3d74b05b042
#rtbassoc-0c00e26dadb1acef9

aws ec2 associate-route-table --route-table-id rtb-0b297578e956e25cf --subnet-id subnet-0b3786d14f6f667c7
#rtbassoc-08848f887ddf6a8ed

aws ec2 associate-route-table --route-table-id rtb-0b297578e956e25cf --subnet-id subnet-0bd67798ea419a9f3
#rtbassoc-0fa753f15bae7ba0d

## Create a DB Subnet Group
aws rds create-db-subnet-group --db-subnet-group-name "rdssubnet" --db-subnet-group-description "This is rds subnet group" --subnet-ids "subnet-0e7fda3d74b05b042" "subnet-0b3786d14f6f667c7" --tags "Key=Name,Value=rds group"

# Create Security Group
aws ec2 create-security-group --description "Ansible Security Group" --group-name "Ansible" --vpc-id vpc-0ce92f05e74948458
#sg-074d5f6fa834f48f9

# Create Security Group Ingress Rules
aws ec2 authorize-security-group-ingress --group-id sg-074d5f6fa834f48f9 --protocol tcp --port 22 --cidr 0.0.0.0/0 

aws ec2 authorize-security-group-ingress --group-id sg-074d5f6fa834f48f9 --protocol tcp --port 80 --cidr 0.0.0.0/0

# Create EC2 Instance 
aws ec2 run-instances --image-id ami-0a313d6098716f372 --instance-type t2.micro --count 1 --subnet-id subnet-0e7fda3d74b05b042 --security-group-ids sg-074d5f6fa834f48f9 --key-name krr --associate-public-ip-address 
