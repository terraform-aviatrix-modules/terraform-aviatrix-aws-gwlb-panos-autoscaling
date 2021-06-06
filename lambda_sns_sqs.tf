resource "aws_iam_role" "LambdaExecutionRole" {
  name               = "LambdaExecutionRole"
  assume_role_policy = file("${path.module}/resources/lambda_iam_role.json")
}

data "template_file" "LambdaExecutionPolicy" {
  template = file("${path.module}/resources/lambda_iam_policy.json.tpl")

  vars = {
    s3_bucket = aws_s3_bucket.aviatrix-palo-alto-bootstrap-bucket.arn
  }
}

resource "aws_iam_policy" "LambdaExecutionPolicy" {
  name   = "LambdaExecutionPolicy"
  policy = data.template_file.LambdaExecutionPolicy.rendered
}

resource "aws_iam_role_policy_attachment" "LambdaExecutionPolicyAttachment" {
  role       = aws_iam_role.LambdaExecutionRole.name
  policy_arn = aws_iam_policy.LambdaExecutionPolicy.arn
}

resource "aws_iam_role" "ASGNotifierRole" {
  name               = "ASGNotifierRole"
  assume_role_policy = file("${path.module}/resources/ASGNotifierRole.json")
}

resource "aws_iam_policy" "ASGNotifierRolePolicy" {
  name   = "ASGNotifierRolePolicy"
  policy = file("${path.module}/resources/ASGNotifierPolicy.json")
}

resource "aws_iam_role_policy_attachment" "ASGNotifierRolePolicyAttachment" {
  role       = aws_iam_role.ASGNotifierRole.name
  policy_arn = aws_iam_policy.ASGNotifierRolePolicy.arn
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

  runtime     = "python3.6"
  memory_size = 512
  timeout     = 900

  vpc_config {
    subnet_ids         = [aws_subnet.LambdaMGMTSubnetAz1.id, aws_subnet.LambdaMGMTSubnetAz2.id, ]
    security_group_ids = [aws_security_group.VPCSecurityGroup.id]
  }
}

resource "aws_lambda_function" "InitLambda" {
  filename         = "${path.module}/resources/panw-aws.zip"
  function_name    = "InitLambda"
  role             = aws_iam_role.LambdaExecutionRole.arn
  handler          = "init.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/resources/panw-aws.zip")

  runtime     = "python3.6"
  memory_size = 256
  timeout     = 900

  vpc_config {
    subnet_ids         = [aws_subnet.LambdaMGMTSubnetAz1.id, aws_subnet.LambdaMGMTSubnetAz2.id, ]
    security_group_ids = [aws_security_group.VPCSecurityGroup.id]
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

resource "aws_lambda_permission" "LambdaENIPermission" {
  statement_id  = "AllowSNSFromLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.FwInit.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.LambdaENISNSTopic.arn
}

# resource "aws_cloudformation_stack" "network" {
#   name = "networking-stack"

#   parameters = {
#     VPCCidr = "10.0.0.0/16"
#   }

#   template_body = <<STACK
# {
#   "Parameters" : {
#     "VPCCidr" : {
#       "Type" : "String",
#       "Default" : "10.0.0.0/16",
#       "Description" : "Enter the CIDR block for the VPC. Default is 10.0.0.0/16."
#     }
#   },
#   "Resources" : {
#     "myVpc": {
#       "Type" : "AWS::EC2::VPC",
#       "Properties" : {
#         "CidrBlock" : { "Ref" : "VPCCidr" },
#         "Tags" : [
#           {"Key": "Name", "Value": "Primary_CF_VPC"}
#         ]
#       }
#     }
#   }
# }
# STACK
# }
