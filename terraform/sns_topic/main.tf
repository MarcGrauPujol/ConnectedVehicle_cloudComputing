data "aws_region" "current" {}

locals {
    alarms_topic = {
        # topic_name = var.topic_name
        topic_email = var.topic_email
    }
}

module "sns_topic_alarms" {
    source = "../modules/sns/topic"

    # topic_name = local.alarms_topic.topic_name
    topic_email = local.alarms_topic.topic_email
    aws_region = "us-east-1"
}
