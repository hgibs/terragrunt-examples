resource "aws_iam_role" "example_ec2_role" {
  name = "example_ec2_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "example_ec2_instance_profile" {
  name = "example_ec2_instance_profile"
  role = aws_iam_role.example_ec2_role.name
}

resource "aws_iam_role_policy_attachment" "attach_s3_all" {
  role       = aws_iam_role.example_ec2_role.name
  policy_arn = aws_iam_policy.s3_all.arn
}

resource "aws_iam_policy" "s3_all" {
  name        = "s3_all"
  path        = "/"
  description = "Read/write all s3 resources"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
