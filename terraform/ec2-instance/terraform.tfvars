aws_region = "us-east-1"
tag_env = "dev"
instance_type = "t2.large"
subnet_id = "subnet-id"
vpc_security_group_ids = "sg-id"
key_name = "KEYNAME"
iam_instance_profile = "ROLE"
user_data = <<-EOF
            #!/bin/sh
            yum -y remove java-1.7.0-openjdk
            yum -y install java-1.8.0-openjdk nrpe
	    chkconfig nrpe on
	    /etc/init.d/nrpe restart
            EOF
