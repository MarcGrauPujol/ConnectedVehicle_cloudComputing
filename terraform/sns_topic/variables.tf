################################################################################
# SNS_Topic
################################################################################
# variable "topic_name" {
#   description = "The name for the topic."
#   type        = string
#   default     = null
# }

variable "topic_email" {
  description = "The email for the topic notification."
  type        = string
  nullable    = false
}
