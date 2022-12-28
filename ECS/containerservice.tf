resource "aws_ecr_repository" "case_study_movierental_ecr_repo" {
  name = "case-study-movierental-ecr-repo" # Naming the repository
}

resource "aws_ecs_cluster" "case_study_movierental_ecs_cluster" {
  name = "case-study-movierental-ecs-cluster"
  tags = {
    Modul      = "pcls",
    Service    = "ECS",
    Komponente = "Cluster"
  }
}

resource "aws_ecs_task_definition" "case_study_movierental_ecs_task" {
  family                   = "case-study-movierental-task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "case-study-movierental-task",
      "image": "${aws_ecr_repository.case_study_movierental_ecr_repo.repository_url}",
      "essential": true,
      "environment": [
        {
          "name": "SPRING_DATASOURCE_URL",
          "value": "jdbc:mysql://mysql:3306/eaf?useSSL=false"
        },
        {
          "name": "SPRING_DATASOURCE_USERNAME",
          "value": "root"
        },
        {
          "name": "SPRING_DATASOURCE_PASSWORD",
          "value": "eaf"
        },
        {
          "name": "SPRING_PROFILES_ACTIVE",
          "value": "prod"
        },
        {
          "name": "TZ",
          "value": "CET"
        }
      ],
      "mountPoints": [
        {
          "containerPath": "/tmp",
          "sourceVolume": "Tmp"
        }
      ],
      "name": "movierental",
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "memory": 512,
      "cpu": 256
    },
    {
      "command": [
        "--default-authentication-plugin=mysql_native_password"
      ],
      "environment": [{
          "name": "MYSQL_DATABASE",
          "value": "eaf"
        },
        {
          "name": "MYSQL_ROOT_PASSWORD",
          "value": "eaf"
        }
      ],
      "essential": true,
      "image": "mysql:latest",
      "mountPoints": [{
        "containerPath": "/var/lib/mysql",
        "sourceVolume": "Db-Data"
      }],
      "name": "mysql",
      "portMappings": [{
        "containerPort": 3306,
        "hostPort": 3306
      }]
    },
    {
      "environment": [{
          "name": "PMA_HOST",
          "value": "mysql"
        },
        {
          "name": "PMA_PORT",
          "value": "3306"
        }
      ],
      "essential": true,
      "image": "phpmyadmin:latest",
      "name": "phpmyadmin",
      "portMappings": [{
        "containerPort": 80,
        "hostPort": 8081
      }]
    }
  ],
  "family": "",
  "volumes": [{
      "host": {
        "sourcePath": "db-data"
      },
      "name": "Db-Data"
    },
    {
      "host": {
        "sourcePath": "/tmp"
      },
      "name": "Tmp"
    }
  ]
}
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]                              # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"                                 # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512                                      # Specifying the memory our container requires
  cpu                      = 256                                      # Specifying the CPU our container requires
  execution_role_arn       = "arn:aws:iam::273859233498:role/LabRole" # replace with your own Account ID

  depends_on = [
    aws_ecs_cluster.case_study_movierental_ecs_cluster
  ]

  tags = {
    Modul      = "pcls",
    Service    = "ECS",
    Komponente = "Task"
  }
}

resource "aws_ecs_service" "movierental_service" {
  name            = "case-study-movierental-service"                            # Naming our first service
  cluster         = aws_ecs_cluster.case_study_movierental_ecs_cluster.id       # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.case_study_movierental_ecs_task.arn # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 3 # Setting the number of containers we want deployed to 3
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn # Referencing our target group

    container_name = aws_ecs_task_definition.case_study_movierental_ecs_task.family
    container_port = 8080 # Specifying the container port
  }

  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}", "${aws_default_subnet.default_subnet_c.id}"]
    assign_public_ip = true                                                # Providing our containers with public IPs
    security_groups  = ["${aws_security_group.service_security_group.id}"] # Setting the security group
  }

  depends_on = [
    aws_ecs_cluster.case_study_movierental_ecs_cluster,
    aws_lb_listener.listener
  ]

  tags = {
    Modul      = "pcls",
    Service    = "ECS",
    Komponente = "Service"
  }
}

resource "aws_security_group" "service_security_group" {
  tags = {
    Modul   = "pcls",
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
    from_port   = 0             # Allowing any incoming port
    to_port     = 0             # Allowing any outgoing port
    protocol    = "-1"          # Allowing any outgoing protocol 
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
  name               = "movierental-lb-tf" # Naming our load balancer
  load_balancer_type = "application"
  subnets = [ # Referencing the default subnets
    "${aws_default_subnet.default_subnet_a.id}",
    "${aws_default_subnet.default_subnet_b.id}",
    "${aws_default_subnet.default_subnet_c.id}"
  ]
  # Referencing the security group
  security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  tags = {
    Modul      = "pcls",
    Service    = "Loadbalancer",
    Komponente = "Loadbalancer"
  }
}

# Creating a security group for the load balancer:
resource "aws_security_group" "load_balancer_security_group" {
  tags = {
    Modul      = "pcls",
    Service    = "Loadbalancer",
    Komponente = "SecurityGroup"
  }
  ingress {
    from_port   = 8080 # Allowing traffic in from port 80
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
  }

  egress {
    from_port   = 0             # Allowing any incoming port
    to_port     = 0             # Allowing any outgoing port
    protocol    = "-1"          # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}



resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_default_vpc.default_vpc.id # Referencing the default VPC
  health_check {
    matcher = "200,301,302"
    path    = "/"
  }
  tags = {
    Modul      = "pcls",
    Service    = "Loadbalancer",
    Komponente = "TargetGroup"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn # Referencing our load balancer
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn # Referencing our target group
  }
}
