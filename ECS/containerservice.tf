resource "aws_ecs_cluster" "case_study_umfrage_ecs_cluster" {
  name = "case-study-umfrage-ecs-cluster"
  tags = {
    Modul = "pcls",
    Service = "ECS",
    Komponente = "Cluster"
  }
}

resource "aws_ecs_task_definition" "case_study_umfrage_ecs_task" {
  family                   = "case-study-umfrage-task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "case-study-umfrage-task",
      "image": "docker.io/martialblog/limesurvey:latest",
      "essential": true,
      "environment": [
        {
          "name": "DATABASE_URL",
          "value": "postgresql://limesurvey:limesurvey$123@rds-limesurvey.cdhkghclow3g.us-east-1.rds.amazonaws.com:5432/limesurvey"
        },
        {
          "name": "RDS_HOSTNAME",
          "value": "rds-limesurvey.cdhkghclow3g.us-east-1.rds.amazonaws.com"
        },
        {
          "name": "RDS_TYPE",
          "value": "pgsql"
        },
        {
          "name": "RDS_PORT",
          "value": "5432"
        },
        {
          "name": "RDS_PASSWORD",
          "value": "limesurvey$123"
        },
        {
          "name": "RDS_DB_NAME",
          "value": "limesurvey"
        },
        {
          "name": "RDS_USERNAME",
          "value": "limesurvey"
        },
        {
          "name": "RDS_ADMIN_USER",
          "value": "admin"
        },
        {
          "name": "RDS_ADMIN_NAME",
          "value": "admin"
        },
        {
          "name": "RDS_ADMIN_PASSWORD",
          "value": "admin$1234"
        },
        {
          "name": "RDS_ADMIN_EMAIL",
          "value": "admin@example.com"
        }
      ],
      "ports": "8080:8080",
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = "arn:aws:iam::273859233498:role/LabRole" # replace with your own Account ID

  tags = {
    Modul = "pcls",
    Service = "ECS",
    Komponente = "Task"
  }
}

resource "aws_ecs_service" "umfrage_service" {
  name            = "case-study-umfrage-service"                             # Naming our first service
  cluster         = "${aws_ecs_cluster.case_study_umfrage_ecs_cluster.id}"             # Referencing our created Cluster
  task_definition = "${aws_ecs_task_definition.case_study_umfrage_ecs_task.arn}" # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 3 # Setting the number of containers we want deployed to 3
  load_balancer {
    target_group_arn = "${aws_lb_target_group.target_group.arn}" # Referencing our target group
    container_name   = "${aws_ecs_task_definition.case_study_umfrage_ecs_task.family}"
    container_port   = 80 # Specifying the container port
  }

  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}", "${aws_default_subnet.default_subnet_c.id}"]
    assign_public_ip = true                                                # Providing our containers with public IPs
    security_groups  = ["${aws_security_group.service_security_group.id}"] # Setting the security group
  }
  tags = {
    Modul = "pcls",
    Service = "ECS",
    Komponente = "Service"
  }
}

resource "aws_security_group" "service_security_group" {
  tags = {
    Modul = "pcls",
    Service = "SecurityGroup",
  }
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0 # Allowing any incoming port
    to_port     = 0 # Allowing any outgoing port
    protocol    = "-1" # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}

# Providing a reference to our default VPC
resource "aws_default_vpc" "default_vpc" {
}

# Providing a reference to our default subnets
resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "us-east-1a"
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "us-east-1b"
}

resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = "us-east-1c"
}

resource "aws_alb" "application_load_balancer" {
  name               = "umfrage-lb-tf" # Naming our load balancer
  load_balancer_type = "application"
  subnets = [ # Referencing the default subnets
    "${aws_default_subnet.default_subnet_a.id}",
    "${aws_default_subnet.default_subnet_b.id}",
    "${aws_default_subnet.default_subnet_c.id}"
  ]
  # Referencing the security group
  security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  tags = {
    Modul = "pcls",
    Service = "Loadbalancer",
    Komponente = "Loadbalancer"
  }
}

# Creating a security group for the load balancer:
resource "aws_security_group" "load_balancer_security_group" {
  tags = {
    Modul = "pcls",
    Service = "Loadbalancer",
    Komponente = "SecurityGroup"
  }
  ingress {
    from_port   = 80 # Allowing traffic in from port 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
  }

  egress {
    from_port   = 0 # Allowing any incoming port
    to_port     = 0 # Allowing any outgoing port
    protocol    = "-1" # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}



resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${aws_default_vpc.default_vpc.id}" # Referencing the default VPC
  health_check {
    matcher = "200,301,302"
    path = "/"
  }
  tags = {
    Modul = "pcls",
    Service = "Loadbalancer",
    Komponente = "TargetGroup"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_alb.application_load_balancer.arn}" # Referencing our load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_group.arn}" # Referencing our target group
  }
}