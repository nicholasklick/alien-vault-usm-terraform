resource "aws_iam_role" "readonly_role_with_cloudtrail" {
  name               = "Alien-Vault-USM-Read-Only-Role-With-Cloudtrail-${var.name}"
  path               = "/"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
} # Indenting here is important in order to ensure correct JSON format

resource "aws_iam_instance_profile" "readonly_role_instance_profile" {
  name = "AlienVault-USM-InstanceProfile-${var.name}"
  path = "/"
  role = "${aws_iam_role.readonly_role_with_cloudtrail.id}"
}  

resource "aws_iam_role_policy" "readonly_policy_with_cloudtrail" {
  name   = "ReadOnlyPolicyWithCloudTrailManagement"
  role = "${aws_iam_role.readonly_role_with_cloudtrail.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudtrail:Describe*",
        "cloudtrail:Get*",
        "cloudtrail:List*",
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "ec2:Describe*",
        "elasticloadbalancing:Describe*",
        "iam:List*",
        "iam:Get*",
        "route53:Get*",
        "route53:List*",
        "rds:Describe*",
        "s3:Get*",
        "s3:List*",
        "sdb:GetAttributes",
        "sdb:List*",
        "sdb:Select*",
        "ses:Get*",
        "ses:List*",
        "sns:Get*",
        "sns:List*",
        "sqs:GetQueueAttributes",
        "sqs:ListQueues",
        "sqs:ReceiveMessage"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "s3:CreateBucket",
        "s3:PutBucketAcl"
      ],
      "Resource": "arn:aws:s3:::usm-cloudtrail-*",
      "Effect": "Allow"
    },
    {
      "Action": "cloudtrail:*",
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "logs:Describe*",
        "logs:Get*",
        "logs:TestMetricFilter"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
POLICY
} # Indenting here is important in order to ensure correct JSON format

resource "aws_iam_role_policy" "publish_to_cloudwatch" {
  name   = "Publish_to_CloudWatch"
  role = "${aws_iam_role.readonly_role_with_cloudtrail.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
POLICY
} # Indenting here is important in order to ensure correct JSON format

