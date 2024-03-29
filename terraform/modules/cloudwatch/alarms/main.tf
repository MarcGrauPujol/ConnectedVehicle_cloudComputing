data "aws_region" "current" {}

resource "aws_cloudwatch_metric_alarm" "alarms" {

  alarm_name = format("%s-%s",
    "alarm",
    var.alarm_name
  )

  alarm_description = var.alarm_description

  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  threshold           = var.threshold
  unit                = var.unit

  metric_name = var.metric_name
  namespace   = var.namespace
  period      = var.period
  statistic   = var.statistic

  datapoints_to_alarm                   = var.datapoints_to_alarm
  treat_missing_data                    = var.treat_missing_data
  evaluate_low_sample_count_percentiles = var.evaluate_low_sample_count_percentiles

  dimensions = var.dimensions

  actions_enabled           = var.actions_enabled
  ok_actions                = var.ok_actions
  insufficient_data_actions = []
  alarm_actions             = var.alarm_actions == null ? [data.aws_sns_topic.this.arn] : var.alarm_actions

  dynamic "metric_query" {
    for_each = var.metric_query
    content {
      id          = lookup(metric_query.value, "id")
      account_id  = lookup(metric_query.value, "account_id", null)
      label       = lookup(metric_query.value, "label", null)
      return_data = lookup(metric_query.value, "return_data", null)
      expression  = lookup(metric_query.value, "expression", null)
      period      = lookup(metric_query.value, "period", null)

      dynamic "metric" {
        for_each = lookup(metric_query.value, "metric", [])
        content {
          metric_name = lookup(metric.value, "metric_name")
          namespace   = lookup(metric.value, "namespace")
          period      = lookup(metric.value, "period")
          stat        = lookup(metric.value, "stat")
          unit        = lookup(metric.value, "unit", null)
          dimensions  = lookup(metric.value, "dimensions", null)
        }
      }
    }
  }
  threshold_metric_id = var.threshold_metric_id
}
