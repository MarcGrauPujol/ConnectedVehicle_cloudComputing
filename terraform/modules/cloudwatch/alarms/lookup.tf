data "aws_sns_topic" "this" {
  name = "topic-for-cloudwatch-alarms"
}
