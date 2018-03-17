variable "vpc_id"{
    default = "vpc-36a78a4f"
}

# you can add more of your vpc's to this 
resource "aws_flow_log" "owasp_flow_log" {
  log_group_name = "${aws_cloudwatch_log_group.owasp_log_group.name}"
  iam_role_arn   = "${aws_iam_role.owasp_log_role.arn}"
  vpc_id         = "${var.vpc_id}"
  traffic_type   = "ALL"
}

resource "aws_cloudwatch_log_group" "owasp_log_group" {
  name = "owasp_flow_lg"
}

resource "aws_iam_role" "owasp_log_role" {
  name = "owasp_flow_log_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "owasp_log_policy" {
  name = "owasp_log_policy"
  role = "${aws_iam_role.owasp_log_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
