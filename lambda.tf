resource "aws_iam_role" "LambdaExecutionRole" {
  name = "LambdaExecutionRole"

  assume_role_policy = <<EOF
{
            "AssumeRolePolicyDocument": {
               "Version": "2012-10-17",
               "Statement": [ {
                 "Effect": "Allow",
                 "Principal": {
                 "Service": "lambda.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
              } ]
            },
            "Path":"/",
            "Policies": [ {
              "PolicyName": "LambdaExecutionRolePolicy",
              "PolicyDocument":{
                "Version": "2012-10-17",
                "Statement": [{
                    "Effect": "Allow",
                    "Action": [ "s3:ListBucket", "s3:GetObject", "s3:ListBucket" ]
                    "Resource": [ "*" ]
                },
                {
                        "Effect": "Allow",
                        "Action": ["iam:UpdateAssumeRolePolicy","iam:GetRole","iam:PassRole", "iam:CreateServiceLinkedRole"],
                        "Resource": ["*"]
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "ec2:ModifyVpcEndpointServicePermissions",
                        "ec2:ModifyTransitGatewayVpcAttachment",
                        "ec2:DescribeTransitGatewayAttachments",
                        "ec2:DescribeTransitGatewayRouteTables",
                        "ec2:CreateTransitGatewayRouteTable",
                        "ec2:DeleteTransitGatewayRouteTable",
                        "ec2:CreateTransitGatewayRoute",
                        "ec2:DeleteTransitGatewayRoute",
                        "ec2:DescribeTransitGateways",
                        "ec2:AllocateAddress",
                        "ec2:AssociateAddress",
                        "ec2:AssociateRouteTable",
                        "ec2:AttachInternetGateway",
                        "ec2:AttachNetworkInterface",
                        "ec2:CreateNetworkInterface",
                        "ec2:CreateTags",
                        "ec2:CreateRoute",
                        "ec2:CreateVpcEndpoint",
                        "ec2:CreateVpcEndpointServiceConfiguration",
                        "ec2:DeleteNetworkInterface",
                        "ec2:DeleteRouteTable",
                        "ec2:DeleteRoute",
                        "ec2:DeleteSecurityGroup",
                        "ec2:DeleteTags",
                        "ec2:DeleteVpcEndpoints",
                        "ec2:DeleteVpcEndpointServiceConfigurations",
                        "ec2:DeleteVpcPeeringConnection",
                        "ec2:DescribeAddresses",
                        "ec2:DescribeRouteTables",
                        "ec2:DescribeAvailabilityZones",
                        "ec2:DescribeVpcEndpointServices",
                        "ec2:DescribeVpcPeeringConnections",
                        "ec2:DescribeInstanceAttribute",
                        "ec2:DescribeInstanceStatus",
                        "ec2:DescribeInstances",
                        "ec2:DescribeImages",
                        "ec2:DescribeNatGateways",
                        "ec2:DescribeNetworkInterfaceAttribute",
                        "ec2:DescribeNetworkInterfaces",
                        "ec2:DescribeTags",
                        "ec2:DescribeVpcEndpoints",
                        "ec2:DescribeVpcs",
                        "ec2:DescribeSubnets",
                        "ec2:DescribeSecurityGroups",
                        "ec2:DetachInternetGateway",
                        "ec2:DetachNetworkInterface",
                        "ec2:DetachVolume",
                        "ec2:DisassociateAddress",
                        "ec2:DisassociateRouteTable",
                        "ec2:ModifyNetworkInterfaceAttribute",
                        "ec2:ModifySubnetAttribute",
                        "ec2:MonitorInstances",
                        "ec2:RebootInstances",
                        "ec2:ReleaseAddress",
                        "ec2:ReportInstanceStatus",
                        "ec2:TerminateInstances",
                        "ec2:DescribeIdFormat",
                        "ec2:RunInstances"
                    ],
                    "Resource": [
                        "*"
                    ]
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "events:*"
                    ],
                    "Resource": [
                        "*"
                    ]
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "cloudwatch:*"
                    ],
                    "Resource": [
                        "*"
                    ]
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "lambda:AddPermission",
                        "lambda:CreateEventSourceMapping",
                        "lambda:CreateFunction",
                        "lambda:DeleteEventSourceMapping",
                        "lambda:DeleteFunction",
                        "lambda:GetEventSourceMapping",
                        "lambda:ListEventSourceMappings",
                        "lambda:RemovePermission",
                        "lambda:UpdateEventSourceMapping",
                        "lambda:UpdateFunctionCode",
                        "lambda:UpdateFunctionConfiguration",
                        "lambda:GetFunction",
                        "lambda:ListFunctions"
                    ],
                    "Resource": [
                        "*"
                    ]
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "autoscaling:*"
                    ],
                    "Resource": [
                        "*"
                    ]
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "sqs:ReceiveMessage",
                        "sqs:SendMessage",
                        "sqs:SetQueueAttributes",
                        "sqs:PurgeQueue",
                        "sqs:DeleteMessage"
                    ],
                    "Resource": [
                        "*"
                    ]
                },

                {
                    "Effect": "Allow",
                    "Action": [
                        "elasticloadbalancing:CreateLoadBalancer",
                        "elasticloadbalancing:CreateListener",
                        "elasticloadbalancing:CreateTargetGroup",
                        "elasticloadbalancing:CreateRule",
                        "elasticloadbalancing:DeleteLoadBalancer",
                        "elasticloadbalancing:DeleteListener",
                        "elasticloadbalancing:DeleteTargetGroup",
                        "elasticloadbalancing:DeleteRule",
                        "elasticloadbalancing:RegisterTargets",
                        "elasticloadbalancing:DeregisterTargets",
                        "elasticloadbalancing:ModifyListener",
                        "elasticloadbalancing:ModifyRule",
                        "elasticloadbalancing:ModifyTargetGroup",
                        "elasticloadbalancing:ModifyTargetGroupAttributes",
                        "elasticloadbalancing:AddTags",
                        "elasticloadbalancing:AttachLoadBalancerToSubnets",
                        "elasticloadbalancing:ConfigureHealthCheck",
                        "elasticloadbalancing:DescribeInstanceHealth",
                        "elasticloadbalancing:DescribeLoadBalancerAttributes",
                        "elasticloadbalancing:DescribeLoadBalancerPolicyTypes",
                        "elasticloadbalancing:DescribeLoadBalancerPolicies",
                        "elasticloadbalancing:DescribeLoadBalancers",
                        "elasticloadbalancing:DescribeTags",
                        "elasticloadbalancing:DetachLoadBalancerFromSubnets",
                        "elasticloadbalancing:ModifyLoadBalancerAttributes",
                        "elasticloadbalancing:RemoveTags",
                        "elasticloadbalancing:DescribeTargetGroups"
                    ],
                    "Resource": [
                        "*"
                    ]
                },
                {
                "Effect": "Allow",
                "Action": ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"],
                "Resource": "arn:aws:logs:*:*:*"
                },
                {
                "Effect": "Allow",
                "Action": ["cloudformation:DescribeStacks"],
                "Resource": "*"
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "logs:CreateLogGroup",
                        "logs:CreateLogStream",
                        "logs:PutDestination",
                        "logs:PutDestinationPolicy",
                        "logs:PutLogEvents",
                        "logs:PutMetricFilter"
                    ],
                    "Resource": [
                        "*"
                    ]
                },
                {
                    "Effect": "Allow",
                    "Action": "dynamodb:*",
                    "Resource": "arn:aws:dynamodb:*:*:*"
                }]
    }}]}
EOF
}


resource "aws_security_group" "VPCSecurityGroup" {
  name        = "VPCSecurityGroup"
  description = "Allow all"
  vpc_id      = var.aviatrix_vpc.vpc_id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "VPCSecurityGroup"
  }
}

resource "aws_lambda_function" "FwInit" {
  filename         = "${path.module}/resources/panw-aws.zip"
  function_name    = "FwInit"
  role             = aws_iam_role.LambdaExecutionRole.arn
  handler          = "fw_init.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/resources/panw-aws.zip")

  runtime            = "python3.6"
  memory_size        = 512
  timeout            = 900

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = [aws_subnet.LambdaMGMTSubnetAz1.id, aws_subnet.LambdaMGMTSubnetAz2.id, ]
    security_group_ids = [aws_security_group.VPCSecurityGroup.id]
  }

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_sqs_queue" "LambdaENIQueue" {
  name = "LambdaENIQueue"
}

resource "aws_sns_topic" "LambdaENISNSTopic" {
  name = "LambdaENISNSTopic"
}

resource "aws_sns_topic_subscription" "LambdaENISNSTopic" {
  topic_arn = aws_sns_topic.LambdaENISNSTopic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.FwInit.arn
}