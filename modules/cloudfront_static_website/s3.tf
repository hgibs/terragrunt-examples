resource "aws_s3_bucket" "static" {
  bucket = "${var.domain_name}-static"
  acl    = "private"

  tags = var.common_tags
}

resource "null_resource" "s3sync_static" {
  provisioner "local-exec" {
    command = "aws s3 sync static_html s3://$BUCKETNAME/"
    environment = {
      BUCKETNAME = aws_s3_bucket.static.bucket
    }
  }
}


resource "aws_s3_bucket_policy" "read_all_static" {
  bucket = aws_s3_bucket.static.id

  policy = <<POLICY
{
  "Id": "Policy1615429016892",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1615429014415",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.static.arn}/*",
      "Principal": "*"
    }
  ]
}
POLICY
}
