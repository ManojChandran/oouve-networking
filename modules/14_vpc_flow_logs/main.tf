#-----------------------14_vpc_flow_logs/main.tf---------------------------
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#--------------------------------------------------------------------------
#-------------variable section----------------------
variable "vpc-id" {}

#-------------data section--------------------------

#-------------control section-----------------------

# Create cloud watch log group to store logs
resource "aws_cloudwatch_log_group" "oouve-cloudwatch" {
  name = "${var.vpc-id}-oouve-cloudwatch"
}

# Create cloud watch vpc flow logs
resource "aws_flow_log" "oouve-flowlogs" {
  iam_role_arn    = "${aws_iam_role.oouve-iam-flowlogs.arn}"
  log_destination = "${aws_cloudwatch_log_group.oouve-cloudwatch.arn}"
  traffic_type    = "ALL"
  vpc_id          = "${var.vpc-id}"
}

# create IAM role to update logs in cloudwatch
resource "aws_iam_role" "oouve-iam-flowlogs" {
  name = "oouve-iam-flowlogs"

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

resource "aws_iam_role_policy" "oouve-iam-role-policy" {
  name = "oouve-iam-role-policy"
  role = "${aws_iam_role.oouve-iam-flowlogs.id}"

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

#-------------output section------------------------

output "flowlogs-id" {
  value = "${aws_flow_log.oouve-flowlogs.id}"
}
