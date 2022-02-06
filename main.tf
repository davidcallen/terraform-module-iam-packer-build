# ---------------------------------------------------------------------------------------------------------------------
# IAM Role for EC2 instance Packer Builder [read-only access to S3 for software install files]
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "packer-build" {
  name = "${var.environment.resource_name_prefix}-packer-build"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Description = "Role for EC2 instance Packer Builder for read-only access to S3 for software install files"
  }
}

resource "aws_iam_policy" "packer-build" {
  name = "${var.environment.resource_name_prefix}-assume-role-packer-files-s3-read"
  description = "Allow assume role in Core account of '${var.packer_s3_bucket_name}' to access software installation files"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": "sts:AssumeRole",
          "Resource": "arn:aws:iam::${var.packer_s3_bucket_account_id}:role/${var.packer_s3_bucket_name}"
      }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "packer-build" {
  role       = aws_iam_role.packer-build.name
  policy_arn = aws_iam_policy.packer-build.arn
}

resource "aws_iam_instance_profile" "packer-build" {
  name = "packer-builder"
  role = aws_iam_role.packer-build.name
}
