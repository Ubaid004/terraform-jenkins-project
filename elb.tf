resource "aws_elb" "zoro-elb" {
  name               = "zoro-elb"
  availability_zones = ["us-east-1a", "us-east-1b"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                 = ["${aws_instance.zoro.id}", "${aws_instance.nami.id}"]
  cross_zone_load_balancing = true
  idle_timeout              = 400
  tags = {
    Name = "Zoro-elb"
  }
}

 /*resource "aws_rds_cluster" "default" {
  cluster_identifier      = "aurora-cluster-zoro"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.11.2"
  availability_zones      = ["us-east-1a", "us-east-1b"]
  database_name           = "zoro-db"
  master_username         = "zoro"
  master_password         = "#Ambakatana004"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
}*/
