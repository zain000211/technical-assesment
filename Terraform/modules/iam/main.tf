resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.ecs_task_execution_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecs_task_execution_policy" {
  name       = "ecs_task_execution_policy_attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  roles      = [var.ecs_task_execution_role]
}

resource "aws_iam_policy" "ecr_execution_policy" {
  name        = "ecr_execution_policy"
  description = "ECR permissions for ECS Task Execution"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecr_execution_policy_attachment" {
  name       = "ecr_execution_policy_attachment"
  policy_arn = aws_iam_policy.ecr_execution_policy.arn
  roles      = [var.ecs_task_execution_role]
}

resource "aws_iam_role" "ecs_task_role" {
  name = var.ecs_task_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_task_custom_policy" {
  name        = "ecs_task_custom_policy"
  description = "Custom policy for ECS Task Role"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecs_task_custom_policy_attachment" {
  name       = "ecs_task_custom_policy_attachment"
  policy_arn = aws_iam_policy.ecs_task_custom_policy.arn
  roles      = [var.ecs_task_role_name]
}


resource "aws_iam_role" "ecs_service_role" {
  name = var.ecs_service_iam_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

