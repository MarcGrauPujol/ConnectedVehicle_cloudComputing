locals {

  alarms = merge({
    "BucketSizeBytes" : {
      comparison_operator       = "GreaterThanThreshold"
      evaluation_periods        = 5
      metric_name               = "BucketSizeBytes"
      namespace                 = "AWS/S3"
      period                    = 60
      statistic                 = "Average"
      threshold                 = 80
      alarm_description         = "The amount of data in bytes that is stored in a bucket."
    }
  },
    # Only for prod env
    {
      "NumberOfObjects" : {
        comparison_operator       = "GreaterThanThreshold"
        evaluation_periods        = 5
        metric_name               = "NumberOfObjects"
        namespace                 = "AWS/RDS"
        period                    = 60
        statistic                 = "Maximum"
        threshold                 = 80
        alarm_description         = "The total number of objects stored in a general purpose bucket."
      }
    }
  )
}

module "rds_alarms" {
  source = "../modules/cloudwatch/alarms"
  for_each = local.alarms

  alarm_name = "s3-bucket-${each.key}"
  comparison_operator       = each.value.comparison_operator
  evaluation_periods        = each.value.evaluation_periods
  metric_name               = each.key
  namespace                 = each.value.namespace
  period                    = each.value.period
  statistic                 = each.value.statistic
  threshold                 = each.value.threshold
  alarm_description         = each.value.alarm_description
  dimensions = {
    BucketName =  "bucket-static-website-for-group-4-project", #No posar el nom hardcoded
    StorageType = "StandardStorage"
  }
}
