output "sns_topic" {
  value       = aws_sns_topic.alarm
  description = "SNS topic."
}

output "sns_topic_name" {
  value       = aws_sns_topic.alarm.name
  description = "SNS topic name."
}

output "sns_topic_id" {
  value       = aws_sns_topic.alarm.id
  description = "SNS topic ID."
}

output "sns_topic_arn" {
  value       = aws_sns_topic.alarm.arn
  description = "SNS topic ARN."
}

output "sns_topic_owner" {
  value       = aws_sns_topic.alarm.owner 
  description = "SNS topic owner."
}