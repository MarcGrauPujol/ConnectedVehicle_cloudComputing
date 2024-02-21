locals {

  alarms = merge({
    "CPUUtilization" : {
      comparison_operator       = "GreaterThanThreshold"
      evaluation_periods        = 5
      metric_name               = "CPUUtilization"
      namespace                 = "AWS/RDS"
      period                    = 60
      statistic                 = "Average"
      threshold                 = 80  #change to 1 to activate the alarm
      alarm_description         = "This metric indicates the cpu utilization"
    }
  },

    {
      "FreeableMemory" : {
        comparison_operator       = "LessThanThreshold"
        evaluation_periods        = 5
        metric_name               = "FreeableMemory"
        namespace                 = "AWS/RDS"
        period                    = 60
        statistic                 = "Maximum"
        threshold                 = 500 #MB
        alarm_description         = "This metric indicates the amount of available random access memory."
      }
    },

    {
      "WriteLatency" : {
        comparison_operator       = "GreaterThanThreshold"
        evaluation_periods        = 5
        metric_name               = "WriteLatency"
        namespace                 = "AWS/RDS"
        period                    = 60
        statistic                 = "Average"
        threshold                 = 0.2
        alarm_description         = "This metric indicates the latency of write operations."
      }
    },

    {
      "MaximumUsedTransactionIDs" : {
        comparison_operator       = "GreaterThanThreshold"
        evaluation_periods        = 5
        metric_name               = "MaximumUsedTransactionIDs"
        namespace                 = "AWS/RDS"
        period                    = 60
        statistic                 = "Maximum"
        threshold                 = 943718400
        alarm_description         = "This metric indicates the maximum number of used transaction IDs.."
      }
    }
  )
}

module "rds_alarms" {
  source = "../modules/cloudwatch/alarms"
  for_each = local.alarms

  alarm_name = "rds-${each.key}"
  comparison_operator       = each.value.comparison_operator
  evaluation_periods        = each.value.evaluation_periods
  metric_name               = each.key
  namespace                 = each.value.namespace
  period                    = each.value.period
  statistic                 = each.value.statistic
  threshold                 = each.value.threshold
  alarm_description         = each.value.alarm_description
  dimensions = {
    DBInstanceIdentifier = "database-1", # hardcoded name
  }
}
