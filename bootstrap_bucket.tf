#Random string for unique s3 bucket
resource "random_string" "bucket" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "aviatrix-palo-alto-bootstrap-bucket" {
  bucket = "aviatrix-palo-alto-bootstrap-bucket-${random_string.bucket.result}"
  acl    = "private"
}
resource "aws_s3_bucket_object" "folder_config" {
  bucket = aws_s3_bucket.aviatrix-palo-alto-bootstrap-bucket.id
  acl    = "private"
  key    = "config/"
  source = "/dev/null"
}
resource "aws_s3_bucket_object" "folder_content" {
  bucket = aws_s3_bucket.aviatrix-palo-alto-bootstrap-bucket.id
  acl    = "private"
  key    = "content/"
  source = "/dev/null"
}
resource "aws_s3_bucket_object" "folder_license" {
  bucket = aws_s3_bucket.aviatrix-palo-alto-bootstrap-bucket.id
  acl    = "private"
  key    = "license/"
  source = "/dev/null"
}
resource "aws_s3_bucket_object" "folder_software" {
  bucket = aws_s3_bucket.aviatrix-palo-alto-bootstrap-bucket.id
  acl    = "private"
  key    = "software/"
  source = "/dev/null"
}

resource "aws_s3_bucket_object" "init" {
  bucket = aws_s3_bucket.aviatrix-palo-alto-bootstrap-bucket.id
  key    = "config/init-cfg.txt"
  source = "${path.module}/resources/init-cfg.txt"
}

resource "aws_iam_role" "FirewallBootstrapRole" {
  name               = "FirewallBootstrapRole"
  assume_role_policy = file("${path.module}/resources/bootstrap_iam_role.json")
}

data "template_file" "aviatrix-palo-alto-bootstrap-iam-policy" {
  template = file("${path.module}/resources/bootstrap_iam_policy.json.tpl")

  vars = {
    s3_bucket = aws_s3_bucket.aviatrix-palo-alto-bootstrap-bucket.arn
  }
}

resource "aws_iam_policy" "aviatrix-palo-alto-bootstrap-iam-policy" {
  name   = "aviatrix-palo-alto-bootstrap-iam-policy"
  policy = data.template_file.aviatrix-palo-alto-bootstrap-iam-policy.rendered
}

resource "aws_iam_role_policy_attachment" "aviatrix-palo-alto-bootstrap-iam-policy-role-attachment" {
  role       = aws_iam_role.FirewallBootstrapRole.name
  policy_arn = aws_iam_policy.aviatrix-palo-alto-bootstrap-iam-policy.arn
}

resource "aws_iam_instance_profile" "aviatrix-palo-alto-bootstrap-iam-instance-profile" {
  name = "aviatrix-palo-alto-bootstrap-iam-instance-profile"
  role = aws_iam_role.FirewallBootstrapRole.name
}
