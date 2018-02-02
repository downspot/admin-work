# linked sections need to change for starting single or multiple services
# currently only one service per instance

aws_region = "us-east-1"
tag_name = "example-preprod"
tag_env = "preprod"
instance_type = "t2.large"
subnet_id = "subnet-id"
vpc_security_group_ids = "sg-id"
key_name = "KEY"
iam_instance_profile = "ROLE"
user_data = <<-EOF
            #!/bin/sh
            yum -y remove java-1.7.0-openjdk
            yum -y install java-1.8.0-openjdk nrpe nagios-plugins-procs
	    #
	    aws s3 cp s3://example/nagios/nrpe.cfg /etc/nagios/
	    aws s3 cp s3://example/nagios/check.cfg /etc/nrpe.d/
	    chkconfig nrpe on
	    /etc/init.d/nrpe restart
	    #
	    aws s3 cp s3://example/daemontools-0.76-1.x86_64.rpm /tmp/
	    rpm -ivh /tmp/daemontools-0.76-1.x86_64.rpm
	    initctl start daemontools
	    #
	    mkdir -p /var/service 
	    aws s3 sync s3://example/joiner /var/service/joiner/
	    aws s3 sync s3://example/clicks_trainer /var/service/clicks_trainer/
	    aws s3 sync s3://example/recs_trainer /var/service/recs_trainer/
	    #
	    chmod +x /var/service/*/run
	    chmod +x /var/service/*/log/run
	    mkdir /var/service/{clicks_trainer,joiner,recs_trainer}/log/main
	    ln -s /var/service/joiner /service
	    #ln -s /var/service/clicks_trainer /service
	    #ln -s /var/service/recs_trainer /service
            EOF
