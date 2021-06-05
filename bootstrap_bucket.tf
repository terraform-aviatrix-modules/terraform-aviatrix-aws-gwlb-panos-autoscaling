resource "aws_s3_bucket" "aviatrix-palo-alto-bootstrap-bucket" {
  bucket = "aviatrix-palo-alto-bootstrap-bucket"
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
resource "aws_s3_bucket_object" "xml" {
  bucket = aws_s3_bucket.aviatrix-palo-alto-bootstrap-bucket.id
  key    = "config/bootstrap.xml"
  source = "bootstrap.xml"
}
resource "aws_s3_bucket_object" "init" {
  bucket = aws_s3_bucket.aviatrix-palo-alto-bootstrap-bucket.id
  key    = "config/init-cfg.txt"
  source = "init-cfg.txt"
}
resource "aws_iam_role" "FirewallBootstrapRole" {
  name               = "FirewallBootstrapRole"
  assume_role_policy = file("${path.module}/resources/bootstrap_iam_policy.json")
}
resource "aws_iam_policy" "aviatrix-palo-alto-bootstrap-iam-policy" {
  name   = "aviatrix-palo-alto-bootstrap-iam-policy"
  policy = file("${path.module}/resources/bootstrap_iam_policy.json")
}
resource "aws_iam_role_policy_attachment" "aviatrix-palo-alto-bootstrap-iam-policy-role-attachment" {
  role       = aws_iam_role.FirewallBootstrapRole.name
  policy_arn = aws_iam_policy.aviatrix-palo-alto-bootstrap-iam-policy.arn
}
resource "aws_iam_instance_profile" "aviatrix-palo-alto-bootstrap-iam-instance-profile" {
  name = "aviatrix-palo-alto-bootstrap-iam-instance-profile"
  role = aws_iam_role.FirewallBootstrapRole.name
}
