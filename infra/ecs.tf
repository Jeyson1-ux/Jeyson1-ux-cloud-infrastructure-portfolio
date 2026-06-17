resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-ecs-cluster"

  tags = {
    Name = "${var.project_name}-ecs-cluster"
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-log-group"
  }
}

resource "aws_iam_role" "ecs_execution" {
  name = "${var.project_name}-ecs-execution-role"

  assume_role_policy = jsonencode({ # Converst HCL to JSON for AWS
    Version = "2012-10-17"
    Statement = [{     # list of permission rules
      Effect = "Allow" # permit this action
      Action = "sts:AssumeRole"
      Principal = {
        Service = "ecs-tasks.amazonaws.com" #ONLY ECS tasks can assume this role
        # not ec2, not lambda, only ecs-tasks!
      }
    }]
  })

  tags = {
    Name = "${var.project_name}-ecs-execution-role"
  }

}

resource "aws_iam_policy" "ecs_execution" {
  name = "${var.project_name}-ecs-execution-policy"

  policy = jsonencode({ # Converst HCL to JSON for AWS
    Version = "2012-10-17"
    Statement = [
      {                  # list of permission rules
        Effect = "Allow" # permit this action
        Action = [
          "ecr:GetAuthorizationToken",       # login to ECR
          "ecr:BatchCheckLayerAvailability", # check image layers exist
          "ecr:GetDownloadUrlForLayer",      # get download URL for image
          "ecr:BatchGetImage"                # pull the actual image
        ]
        Resource = "*" # ECR auth works at account level, needs *

      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream", # create log stream in CloudWatch
          "logs:PutLogEvents"
        ]

        Resource = "${aws_cloudwatch_log_group.main.arn}:*"
      },
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = aws_secretsmanager_secret.db.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role = aws_iam_role.ecs_execution.name # which role to attach to

  policy_arn = aws_iam_policy.ecs_execution.arn # which policy to attach

}

resource "aws_ecs_task_definition" "main" {
  family                   = "${var.project_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256 # 0.25 vCPU
  memory                   = 512 # 512 MB RAM
  execution_role_arn       = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([{
    name  = "${var.project_name}-container"
    image = "nginx:latest"
    portMappings = [{
      containerPort = 80
      protocol      = "tcp"
    }]

    secrets = [{ # pass secret securely, not as plain text!
      name      = "DATABASE_URL"
      valueFrom = aws_secretsmanager_secret.db.arn # fetch from secrets manager
    }]
    logConfiguration = { # It sends logs to cloudwatch
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.main.name
        awslogs-region        = var.region
        awslogs-stream-prefix = "ecs"
      }

    }
  }])


}