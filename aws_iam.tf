resource "aws_iam_policy" "ECS-Exec-Fargate" {
  name="ECS-Exec-Fargate"
  policy = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:CreateControlChannel"
            ],
            "Resource": "*"
     }
  ]
})
}

resource "aws_iam_role" "ECS-Exec-Fargate-role" {
  name = "ECS-Exec-Fargate-role"

  assume_role_policy = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
        "Effect": "Allow",
        "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }
  ]
})
}

resource "aws_iam_policy" "ECS-Task-Execution-Role-Policy" {
  name="ECS-Task-Execution-Role-Policy"
  policy = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
          ],
          "Resource": "*"
      }
  ]
})
}

resource "aws_iam_role_policy_attachment" "ECS-Exec-Fargate-role-Policy" {
  role       = aws_iam_role.ECS-Exec-Fargate-role.name
  policy_arn = aws_iam_policy.ECS-Exec-Fargate.arn
}

resource "aws_iam_role" "ECS-Task-Execution-Role" {
  name = "ECS-Task-Execution-Role"

  assume_role_policy = jsonencode(
{
  "Version": "2008-10-17",
  "Statement": [
    {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }
  ]
})
}

resource "aws_iam_role_policy_attachment" "ECS-Task-Execution-Role-Policy" {
  role       = aws_iam_role.ECS-Task-Execution-Role.name
  policy_arn = aws_iam_policy.ECS-Task-Execution-Role-Policy.arn
}